class MicroblogController < ApplicationController

  before_filter :get_following_microblog, :only => [:local_feed, :followings_feed, :followings, :add_following, :remove_following]
  before_filter :get_follower_microblog, :only => [:followers_feed, :followers]

  # Глобальная лента
  def global_feed
    # Получение всех постов с сортировкой по дате создания
    @posts_count, @posts = get_posts(MicroblogPost.all.desc(:created_at))
  end

  def local_feed
    # Получение постов пользователей, на кого подписан пользователь
    @posts_count, @posts = get_posts(MicroblogPost.
                                       where(:author_id.in => @user.microblog.following_ids << @user.id).
                                       desc(:created_at))
  end

  # Персональная лента
  def personal_feed
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
    @followings = @user.microblog.followings
  end

  # Читатели микроблога пользователя
  def followers
    @followers = @user.microblog.followers
  end

  def add_following
  end

  def remove_following
  end

  def create_post
  end

  def delete_post
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
             only(:id, :username, "user_profile.first_name", "user_profile.last_name").
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
                             only(:owner_id, :following_ids, :followings_count)
    end

    def get_follower_microblog
      @microblog = Microblog.where(:owner_id => @user.id).
                             only(:owner_id, :follower_ids, :followers_count)
    end

end
