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
  before_filter :get_current_microblog

  # Глобальная лента
  def global_feed
    if @personal
      @new_post = MicroblogPost.new
    end
    # Получение всех постов с сортировкой по дате создания
    @posts_count, @posts = get_posts(MicroblogPost.all.desc(:created_at).
                                       paginate(:page => params[:page], :per_page => 10))
  end

  def local_feed
    if @personal
      @new_post = MicroblogPost.new
    end
    # Получение постов пользователей, на кого подписан пользователь
    @posts_count, @posts = get_posts(MicroblogPost.
                                       where(:author_id.in => @user.microblog.following_ids << @user.id).
                                       desc(:created_at).
                                       paginate(:page => params[:page], :per_page => 10))
  end

  # Персональная лента
  #
  # Выводит персональную ленту пользователя.
  # 
  # Определяет количество постов пользователя, если лента не текущего пользователя,
  # то читает ли его текущий пользователь.
  #
  # Если пользователь текущий: генерирует новый MicroblogPost объект для формы.
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
      @posts = @user.microblog_posts.desc(:created_at).paginate :page => params[:page], :per_page => 10
    else
      @posts = nil
    end
  end

  def followings_feed
    # Получение постов пользователей, на кого подписан пользователь
    @posts_count, @posts = get_posts(MicroblogPost.
                                       where(:author_id.in => @user.microblog.following_ids).
                                       desc(:created_at).
                                       paginate(:page => params[:page], :per_page => 10))
  end

  def followers_feed
    # Получение постов, подписчиков пользователей
    @posts_count, @posts = get_posts(MicroblogPost.
                                       where(:author_id.in => @user.microblog.follower_ids).
                                       desc(:created_at).
                                       paginate(:page => params[:page], :per_page => 10))
  end

  ##############################################################################
  # Расстановка флагов вынесена в функцию subscribing_status. Функция использует,
  # для установки флага поле User#buffer.

  # TO-DO: сделать что-нить с only. Scopes не работают для only, а большое 
  #        количество параметров режет глаз.

  # TO-DO: сделать настройку для установки количества пользователей на страницу.
  #        Это на очень далекое будущее. Так, чтобы не держать в голове.

  # Кого читает пользователь
  def followings
    # Если подписок нет, то нет смысла делать запросы (: 
    unless @microblog.followings_count == 0
      @followings = @microblog.followings.
                               only(:id, :username, "user_profile.first_name", 
                                    "user_profile.last_name", "user_profile.avatar",
                                    "user_profile.org_name", "user_profile.org_unit",
                                    "user_profile.org_position").
                               paginate(:page => params[:page], :per_page => 10)
      # Если страница подписок текущего пользователя,
      # то гарантируется, что у всех пользователей будет стоять флаг :follow,
      # поэтому в качестве оптимизации используется это условие.
      unless @personal
        subscribing_status(@followings)
      end   
    end
  end

  # Читатели микроблога пользователя
  def followers
    # Если подписчиков нет, то нет смысла делать запросы (:
    unless @microblog.followers_count == 0
      @followers = @microblog.followers.
                              only(:id, :username, "user_profile.first_name", 
                                   "user_profile.last_name", "user_profile.avatar",
                                   "user_profile.org_name", "user_profile.org_unit",
                                   "user_profile.org_position").
                              paginate(:page => params[:page], :per_page => 10)
      # Выставляется статус подписки. Даже для страницы текущего пользователя,
      # не гарантируется, что у всех пользователей одинаковый статус.
      subscribing_status(@followers)
    end
  end

  ##############################################################################

  # Следить за микроблогом пользователя
  def add_following
    following = User.username(params[:following]).only(:id).first
    unless following.nil?
      following_microblog = Microblog.where(:owner_id => following.id).first
      unless following_microblog.nil?
        # Занесение following связи
        unless @microblog.following?(following.id)
          @microblog.following_ids << following.id
        end
        @microblog.followings_count = @microblog.following_ids.size
        @microblog.save
        # Занесение follower связи
        unless following_microblog.follower?(@user.id)
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
        if @microblog.following?(following.id)
          @microblog.following_ids.delete(following.id)
        end
        @microblog.followings_count = @microblog.following_ids.size
        @microblog.save
        # Занесение follower связи
        if following_microblog.follower?(@user.id)
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

    # Если выводится страница не текущего пользователя,
    # то может понадобиться Microblog текущего пользователя.
    # К примеру, когда нужно получать статус подписки. 
    #
    # Костыль, причем не оптимизированный.
    def get_current_microblog
      @current_microblog = current_user.microblog
    end

    # Получение постов, и получение их авторов
    #
    # Функция используется для вытягивания информации об авторах за один запрос,
    # и присвоение ее соответствующим постам.
    def get_posts(collection)
      # Получение количества постов
      posts_count = collection.size
      unless posts_count == 0
        # Генерация списка id авторов постов
        author_ids = collection.map { |post| post.author_id }
        author_ids.uniq!
        # Получение авторов постов по id
        authors = Hash.new
        User.where(:_id.in => author_ids.uniq).
             only(:id, :username, "user_profile.first_name", "user_profile.last_name", "user_profile.avatar").
             each do |author|
          authors[author.id] = author
        end
        # Присваивание авторов постам по author_id
        collection.each do |post|
          post.author = authors[post.author_id]
        end
        return posts_count, collection
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

    # Функции внутреннего использования

    # Проходит по пользователям, и выставляет статус отношения подписки.
    #
    # Для установки флага используется User#buffer. Должно использоваться,
    # только в шаблонах (!!!).
    def subscribing_status(users)
      users.each do |u|
        if u.id == current_user.id
          # Это текущий пользователь
          u.buffer = :self
        else
          if @current_microblog.following?(u.id)
            # Текущий пользователь подписан на указанного
            u.buffer = :follow
          else
            # Текущий пользователь не подписан на указанного
            u.buffer = :unfollow
          end
        end
      end
    end

end
