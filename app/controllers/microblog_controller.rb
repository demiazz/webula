class MicroblogController < ApplicationController

  before_filter :get_following_microblog, :only => [:local_feed, 
                                                    :followings_feed, 
                                                    :followings, 
                                                    :add_following, 
                                                    :remove_following]
  before_filter :get_follower_microblog, :only => [:followers_feed, 
                                                   :followers]
  before_filter :get_microblog, :only => [:create_post, 
                                          :delete_post]

  # Глобальная лента
  def global_feed
    if @personal
      @new_post = MicroblogPost.new
    end
    # Получение всех постов с сортировкой по дате создания
    @posts_count, @posts = get_posts(MicroblogPost.all.desc(:created_at))
  end

  def local_feed
    if @personal
      @new_post = MicroblogPost.new
    end
    # Получение постов пользователей, на кого подписан пользователь
    @posts_count, @posts = get_posts(MicroblogPost.
                                       where(:author_id.in => @user.microblog.following_ids << @user.id).
                                       desc(:created_at))
  end

  # Персональная лента
  def personal_feed
    if @personal
      @microblog = Microblog.where(:owner_id => @user.id).only(:posts_count).first
      @new_post = MicroblogPost.new
    else
      @microblog = Microblog.where(:owner_id => @user.id).only(:follower_ids, :posts_count).first
      @follow = @microblog.follower_ids.include?(current_user.id)
    end
    # Получение количества постов
    @posts_count = @microblog.posts_count
    # Если посты есть - получение постов
    unless @posts_count == 0
      @posts = @user.microblog_posts.desc(:created_at)
    else
      @posts = nil
    end
  end

  def followings_feed
    # Получение постов пользователей, на кого подписан пользователь
    @posts_count, @posts = get_posts(MicroblogPost.
                                       where(:author_id.in => @user.microblog.following_ids).
                                       desc(:created_at))
  end

  def followers_feed
    # Получение постов, подписчиков пользователей
    @posts_count, @posts = get_posts(MicroblogPost.
                                       where(:author_id.in => @user.microblog.follower_ids).
                                       desc(:created_at))
  end

  # Кого читает пользователь
  def followings
    unless @microblog.followings_count == 0
      @followings = User.where(:_id.in => @microblog.following_ids).
                    only(:id, :username, "user_profile.first_name", 
                         "user_profile.last_name", "user_profile.avatar",
                         "user_profile.org_name", "user_profile.org_unit",
                         "user_profile.org_position")
    end
  end

  # Читатели микроблога пользователя
  def followers
    unless @microblog.followers_count == 0
      @followers = User.where(:_id.in => @microblog.follower_ids).
                        only(:id, :username, "user_profile.first_name", 
                        "user_profile.last_name", "user_profile.avatar",
                        "user_profile.org_name", "user_profile.org_unit",
                        "user_profile.org_position")
    end
  end

  # Следить за микроблогом пользователя
  def add_following
    following = User.where(:username => params[:following]).only(:id).first
    unless following.nil?
      following_microblog = Microblog.where(:owner_id => following.id).first
      unless following_microblog.nil?
        # Занесение following связи
        unless @microblog.following_ids.include?(following.id)
          @microblog.following_ids << following.id
        end
        @microblog.followings_count = @microblog.following_ids.size
        @microblog.save
        # Занесение follower связи
        unless following_microblog.follower_ids.include?(@user.id)
          following_microblog.follower_ids << @user.id
        end
        following_microblog.followers_count = following_microblog.follower_ids.size
        following_microblog.save
      end
    end
    redirect_to :back
  end

  # Перестать следить за микроблогом пользователя
  def remove_following
    following = User.where(:username => params[:following]).only(:id).first
    unless following.nil?
      following_microblog = Microblog.where(:owner_id => following.id).first
      unless following_microblog.nil?
        # Занесение following связи
        if @microblog.following_ids.include?(following.id)
          @microblog.following_ids.delete(following.id)
        end
        @microblog.followings_count = @microblog.following_ids.size
        @microblog.save
        # Занесение follower связи
        if following_microblog.follower_ids.include?(@user.id)
          following_microblog.follower_ids.delete(@user.id)
        end
        following_microblog.followers_count = following_microblog.follower_ids.size
        following_microblog.save
      end
    end
    redirect_to :back
  end

  # Создать пост
  def create_post
    post = MicroblogPost.new
    post.author = @user
    post.text = params[:microblog_post][:text]
    @microblog.inc(:posts_count, 1) if post.save
    redirect_to :back
  end

  # Удалить пост
  def delete_post
    # Поиск поста по переданному id, и по id автора равному id текущего пользователя
    post = MicroblogPost.where(:_id => params[:id], :author_id => @user.id).first
    # Если такой пост найден - удаление
    unless post.nil?
      @microblog.inc(:posts_count, -1) if post.destroy
    end
    redirect_to :back
  end

  protected

    # Получение постов, и получение их авторов
    #
    # Функция используется для вытягивания информации об авторах за один запрос,
    # и присвоение ее соответствующим постам.
    def get_posts(query)
      # Получение количества постов
      posts_count = query.count
      unless posts_count == 0
        # Получение постов по запросу
        posts = query.to_a
        # Генерация списка id авторов постов
        author_ids = posts.map { |post| post.author_id } .uniq!
        # Получение авторов постов по id
        authors = Hash.new
        User.where(:_id.in => author_ids.uniq).
             only(:id, :username, "user_profile.first_name", "user_profile.last_name", "user_profile.avatar").
             each do |author|
          authors[author.id] = author
        end
        # Присваивание авторов постам по author_id
        posts.each do |post|
          post.author = authors[post.author_id]
        end
        return posts_count, posts
      else
        return posts_count, nil
      end
    end

  private

    def get_following_microblog
      @microblog = Microblog.where(:owner_id => @user.id).
                             only(:owner_id, :following_ids, :followings_count, :followers_count).
                             first
    end

    def get_follower_microblog
      @microblog = Microblog.where(:owner_id => @user.id).
                             only(:owner_id, :follower_ids, :followings_count, :followers_count).
                             first
    end

    def get_microblog
      @microblog = Microblog.where(:owner_id => @user.id).
                             only(:owner_id, :posts_count).
                             first
    end

end
