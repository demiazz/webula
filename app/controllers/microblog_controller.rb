# -*- coding: utf-8 -*-

=begin

================================================================================

Class: MicroblogController

Description:
  Контроллер микроблогов.

  Условно делится на две части: Feeds и Subscribes.

  Feeds - агрегаторы постов по разным параметрам.
  Subscribes - модуль управления подписками.

Feeds:
  Имеется пять типов лент:
    * Global - лента всех постов, которые на данный момент есть в микроблоге.
    * Local - лента всех постов, принадлежащих пользователю, и тем, кого он
              читает
    * Personal - лента всех постов пользователя, и только его.
    * Followings - лента постов только тех, кого читает пользователь.
    * Followers - лента постов читателей пользователя.

Subscribes:
  Имеется три типа пользователей в терминологии подписки:
    * Текущий пользователь
    * Following - пользователь, кого читает текущий пользователь
    * Follower - пользователь, который читает текущего пользователя.

================================================================================

Actions:
  global_feed - Глобальная лента
  local_feed - Локальная лента
  personal_feed - Персональная лента
  followings_feed - Лента following'ов
  followers_feed - Лента follower'ов
  create_post - Создание поста
  delete_post - Удаление поста
  followings - Те, кого читает текущий пользователь
  followers - Те, кто читает текущего пользователя
  add_following - Добавить пользователя в список подписки 
                  текущего пользователя
  remove_following - Удалить пользователя из списка подписки 
                     текущего пользователя

================================================================================

Copyright (c) 2011, Alexey Plutalov
License: GPL

================================================================================

=end

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

  #=============================================================================
  # Feeds - Агрегаторы постов
  #=============================================================================

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


  #=============================================================================
  # Subscribes - управление подписками
  #=============================================================================

  # Method: MicroblogController#followings
  #
  # Description:
  #   Выводит список всех пользователей, кого читает пользователь.
  #   Если страница текущего пользователя, то:
  #     * гарантировано, что все пользователи будут иметь статус :follow.
  #   Если страница не текущего пользователя, то:
  #     * выводит ссылки на добавление/удаление подписки в зависимости от
  #       статуса пользователя.
  def followings
    unless @microblog.followings_count == 0
      @followings = @microblog.followings.
                               only(:id, :username, "user_profile.first_name", 
                                    "user_profile.last_name", "user_profile.avatar",
                                    "user_profile.org_name", "user_profile.org_unit",
                                    "user_profile.org_position").
                               paginate(:page => params[:page], :per_page => 10)
      unless @personal
        subscribing_status(@followings)
      end   
    end
  end

  # Method: MicroblogController#followers
  #
  # Description:
  #   Выводит список всех пользователей, кто читает пользователя.
  #   Выводит ссылки на добавление/удаление подписки, в зависимости от статуса
  #   пользователя.
  def followers
    unless @microblog.followers_count == 0
      @followers = @microblog.followers.
                              only(:id, :username, "user_profile.first_name", 
                                   "user_profile.last_name", "user_profile.avatar",
                                   "user_profile.org_name", "user_profile.org_unit",
                                   "user_profile.org_position").
                              paginate(:page => params[:page], :per_page => 10)
      subscribing_status(@followers)
    end
  end

  # Method: MicroblogController#add_following
  #
  # Description:
  #   Добавляет подписку пользователя на другого пользователя.
  #
  #   При добавлении отношения количество отношений не икрементрируется,
  #   а устанавливается равным размеру массива с id пользователей 
  #   соответствующего отношения.
  def add_following
    following = User.username(params[:following]).only(:id).first
    unless following.nil? or following.microblog.nil?
      @microblog.add_following!(following.id)
      following.microblog.add_follower!(@user.id)
    end
    redirect_to :back
  end

  # Method: MicroblogController#remove_following
  #
  # Description:
  #   Удаляет подписку пользователя на другого пользователя.
  #
  #   При удалении отношения количество отношений не декрементрируется,
  #   а устанавливается равным размеру массива с id пользователей 
  #   соответствующего отношения.
  def remove_following
    following = User.username(params[:following]).only(:id).first
    unless following.nil? or following.microblog.nil?
      @microblog.remove_following!(following.id)
      following.microblog.remove_follower!(@user.id)
    end
    redirect_to :back
  end

  #=============================================================================
  # Фильтры
  #=============================================================================

  protected

    def get_following_microblog
      @microblog = Microblog.where(:owner_id => @user.id).
                             only(:owner_id, :following_ids, 
                                  :followings_count, :followers_count).
                             first
    end

    def get_follower_microblog
      @microblog = Microblog.where(:owner_id => @user.id).
                             only(:owner_id, :follower_ids, 
                                  :followings_count, :followers_count).
                             first
    end

    def get_microblog
      @microblog = Microblog.where(:owner_id => @user.id).
                             only(:owner_id, :posts_count).
                             first
    end

    # Если выводится страница не текущего пользователя,
    # то может понадобиться Microblog текущего пользователя.
    # К примеру, когда нужно получать статус подписки. 
    #
    # Костыль, причем не оптимизированный.
    def get_current_microblog
      @current_microblog = current_user.microblog
    end

  #=============================================================================
  # Внутренние функции
  #=============================================================================

  private

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

end
