class MicroblogController < ApplicationController

  before_filter :get_following_microblog, :only => [:local_feed, :followings_feed, :followings, :add_following, :remove_following]
  before_filter :get_follower_microblog, :only => [:followers_feed, :followers]

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
      @new_post = MicroblogPost.new
    end
    # Получение количества постов
    @posts_count = @user.microblog_posts.desc(:created_at).count
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

  def add_following
  end

  def remove_following
  end

  # Создать пост
  def create_post
    post = MicroblogPost.new
    post.author = @user
    post.text = params[:microblog_post][:text]
    post.save
    redirect_to :back
  end

  # Удалить пост
  def delete_post
    # Поиск поста по переданному id, и по id автора равному id текущего пользователя
    post = MicroblogPost.where(:_id => params[:id], :author_id => @user.id).first
    # Если такой пост найден - удаление
    unless post.nil?
      post.destroy
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
                             only(:owner_id, :following_ids, :followings_count).
                             first
    end

    def get_follower_microblog
      @microblog = Microblog.where(:owner_id => @user.id).
                             only(:owner_id, :follower_ids, :followers_count).
                             first
    end

end
