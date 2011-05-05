# -*- coding: utf-8 -*-

=begin

================================================================================

Class: MicroblogController

Description:
  Контроллер микроблогов.

  Условно делится на две части: Feeds и Subscribes:
    * Feeds       агрегаторы постов по разным параметрам.
    * Subscribes  модуль управления подписками.

Feeds:
  Имеется пять типов лент:
    * Global      лента всех постов, которые на данный момент есть в микроблоге.
    * Local       лента всех постов, принадлежащих пользователю, и тем, кого он
                  читает
    * Personal    лента всех постов пользователя, и только его.
    * Followings  лента постов только тех, кого читает пользователь.
    * Followers   лента постов читателей пользователя.

Subscribes:
  Имеется три типа пользователей в терминологии подписки:
    * Текущий пользователь
    * Following   пользователь, кого читает текущий пользователь
    * Follower    пользователь, который читает текущего пользователя.

================================================================================

Actions:
  * global_feed        Глобальная лента
  * local_feed         Локальная лента
  * personal_feed      Персональная лента
  * followings_feed    Лента following'ов
  * followers_feed     Лента follower'ов
  * create_post        Создание поста
  * delete_post        Удаление поста
  * followings         Те, кого читает текущий пользователь
  * followers          Те, кто читает текущего пользователя
  * add_following      Добавить пользователя в список подписки
                       текущего пользователя
  * remove_following   Удалить пользователя из списка подписки
                       текущего пользователя

================================================================================

Copyright (c) 2011, Alexey Plutalov <demiazz.py@gmail.com>

================================================================================

=end

class MicroblogController < ApplicationController

  before_filter :new_post_filter, :only => [:global_feed,
                                            :local_feed,
                                            :personal_feed]

  before_filter :follow_flag_filter

  before_filter :get_followings_filter, :only => [:local_feed,
                                                  :followings_feed,
                                                  :followings,
                                                  :add_following,
                                                  :remove_following]

  before_filter :get_followers_filter, :only => [:followers_feed,
                                                 :followers]

  before_filter :get_posts_count_filter, :only => [:global_feed,
                                                   :favorites_feed,
                                                   :personal_feed,
                                                   :create_post,
                                                   :delete_post,
                                                   :recommend_post,
                                                   :unrecommend_post,
                                                   :favorite_post,
                                                   :unfavorite_post]

  before_filter :top

  #=============================================================================
  # Feeds - Агрегаторы постов
  #=============================================================================

  # Method: MicroblogController#global_feed
  #
  # Description:
  #   Лента постов всех пользователей.
  #   Возможно создание постов.
  def global_feed
    @posts_count, @posts = get_posts(MicroblogPost.all_posts.
                                                   only(:id, :author_id, :text,
                                                        :created_at))
  end

  # Method: MicroblogController#local_feed
  #
  # Description:
  #   Лента постов пользователей, на кого подписан текущий пользователь, а также
  #   самого пользователя.
  #   Возможно создание постов, если это лента текущего пользователя.
  def local_feed
    case params[:recommends]
    when "enable"
      @posts_count,
      @posts = get_posts(MicroblogPost.any_of({:author_id.in => @user.microblog.following_ids << @user.id},
                                              {:recommend_ids.in => @user.microblog.following_ids << @user.id}).
                                       only(:id, :author_id, :text,
                                            :created_at))
    when "disable"
      @posts_count,
      @posts = get_posts(MicroblogPost.where(:author_id.in => @user.microblog.following_ids << @user.id).
                                       only(:id, :author_id, :text,
                                            :created_at))
    when "only"
      @posts_count,
      @posts = get_posts(MicroblogPost.where(:recommend_ids.in => @user.microblog.following_ids << @user.id).
                                       only(:id, :author_id, :text,
                                            :created_at))
    else
      @posts_count,
      @posts = get_posts(MicroblogPost.any_of({:author_id.in => @user.microblog.following_ids << @user.id},
                                              {:recommend_ids.in => @user.microblog.following_ids << @user.id}).
                                       only(:id, :author_id, :text,
                                            :created_at))
    end
  end

  # Method: MicroblogController#personal_feed
  #
  # Description:
  #   Выводит сообщения пользователя.
  #   Если пользователь не текущий, то отображает кнопку Follow/Unfollow.
  def personal_feed
    case params[:recommends]
    when "enable"
      @posts_count,
      @posts = get_posts(MicroblogPost.any_of({:author_id => @user.id},
                                              {:recommend_ids => @user.id}))
    when "disable"
      @posts_count,
      @posts = get_posts(MicroblogPost.where(:author_id => @user.id))
    when "only"
      @posts_count,
      @posts = get_posts(MicroblogPost.where(:recommend_ids => @user.id))
    else
      @posts_count,
      @posts = get_posts(MicroblogPost.any_of({:author_id => @user.id},
                                              {:recommend_ids => @user.id}))
    end
  end

  # Method: MicroblogController#following_feed
  #
  # Description:
  #   Лента постов пользователей, на кого подписан текущий пользователь.
  def followings_feed
    case params[:recommends]
    when "enable"
      @posts_count,
      @posts = get_posts(MicroblogPost.any_of({:author_id.in => @user.microblog.following_ids},
                                              {:recommend_ids.in => @user.microblog.following_ids}))
    when "disable"
      @posts_count,
      @posts = get_posts(MicroblogPost.where(:author_id.in => @user.microblog.following_ids))
    when "only"
      @posts_count,
      @posts = get_posts(MicroblogPost.where(:recommend_ids.in => @user.microblog.following_ids))
    else
      @posts_count,
      @posts = get_posts(MicroblogPost.any_of({:author_id.in => @user.microblog.following_ids},
                                              {:recommend_ids.in => @user.microblog.following_ids}))
    end
  end

  # Method: MicroblogController#follower_feed
  #
  # Description:
  #   Лента постов пользователей, кто подписан на текущего пользователя.
  def followers_feed
    case params[:recommends]
    when "enable"
      @posts_count,
      @posts = get_posts(MicroblogPost.any_of({:author_id.in => @user.microblog.follower_ids},
                                              {:recommend_ids.in => @user.microblog.follower_ids}))
    when "disable"
      @posts_count,
      @posts = get_posts(MicroblogPost.where(:author_id.in => @user.microblog.follower_ids))
    when "only"
      @posts_count,
      @posts = get_posts(MicroblogPost.where(:recommend_ids.in => @user.microblog.follower_ids))
    else
      @posts_count,
      @posts = get_posts(MicroblogPost.any_of({:author_id.in => @user.microblog.follower_ids},
                                              {:recommend_ids.in => @user.microblog.follower_ids}))
    end
  end

  def favorites_feed
    @posts_count,
    @posts = get_posts(MicroblogPost.where(:favorite_ids => @user.id))
  end

  # Method: MicroblogController#create_post
  #
  # Desctiption:
  #   Создает пост, и возвращает обратно на страницу, с которой пришел запрос.
  #   
  #   Помимо создания поста, делает кэширование количества постов, в микроблоге
  #   пользователя (используется для быстрого получения статистики, 
  #   без лишних запросов к базе).
  def create_post
    post = MicroblogPost.new
    post.author = @user 
    post.text = params[:microblog_post][:text]
    @microblog.inc(:posts_count, 1) if post.save
    redirect_to :back
  end

  # Method: MicroblogController#delete_post
  #
  # Description:
  #   Удаляет пост, и возвращает обратно на страницу, с которой пришел запрос.
  # 
  #   Текущий пользователь может удалять только свои посты. Для этого, в запросе,
  #   указывается не только номер поста, но также и его id автора.
  #   Если пост с указанным id, и id автора не будет найден, то удаление не 
  #   производится.
  def delete_post
    # Поиск нужного поста с указанием автора
    post = MicroblogPost.where(:_id => params[:id], :author_id => @user.id).first
    # Если такой пост найден - удаление
    unless post.nil?
      @microblog.inc(:posts_count, -1) if post.destroy
    end
    redirect_to :back
  end

  def recommend_post
    # Поиск нужного поста с указанием автора
    post = MicroblogPost.where(:_id => params[:id]).
                         where(:author_id.ne => @user.id).
                         where(:recommend_ids.ne => @user.id).
                         only(:recommend_ids, :recommends_count).
                         first
    unless post.nil?
      post.recommend_ids << @user.id
      post.recommends_count = post.recommend_ids.size
      post.save

      @microblog.recommends_count += 1
      @microblog.save
    end
    redirect_to :back
  end

  def unrecommend_post
    # Поиск нужного поста с указанием автора
    post = MicroblogPost.where(:_id => params[:id]).
                         where(:author_id.ne => @user.id).
                         where(:recommend_ids => @user.id).
                         only(:recommend_ids, :recommends_count).
                         first
    unless post.nil?
      post.recommend_ids.delete(@user.id)
      post.recommends_count = post.recommend_ids.size
      post.save

      @microblog.recommends_count -= 1
      @microblog.save
    end
    redirect_to :back
  end

  def favorite_post
    # Поиск нужного поста с указанием автора
    post = MicroblogPost.where(:_id => params[:id]).
                         where(:author_id.ne => @user.id).
                         where(:favorite_ids.ne => @user.id).
                         only(:favorite_ids, :favorites_count).
                         first
    unless post.nil?
      post.favorite_ids << @user.id
      post.favorites_count = post.favorite_ids.size
      post.save

      @microblog.favorites_count += 1
      @microblog.save
    end
    redirect_to :back
  end

  def unfavorite_post
    # Поиск нужного поста с указанием автора
    post = MicroblogPost.where(:_id => params[:id]).
                         where(:author_id.ne => @user.id).
                         where(:favorite_ids => @user.id).
                         only(:favorite_ids, :favorites_count).
                         first
    unless post.nil?
      post.favorite_ids.delete(@user.id)
      post.favorites_count = post.favorite_ids.size
      post.save

      @microblog.favorites_count -= 1
      @microblog.save
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

    # Method: MicroblogController#new_post_filter
    #
    # Description:
    #   Если страница текущего пользователя, то создается пустой пост для формы.
    def new_post_filter
      if @personal
        @new_post = MicroblogPost.new
      end
    end

    # Method: MicroblogController#follow_flag_filter
    #
    # Description:
    #   Устанавливает флаг отношения following между пользователем и текущим
    #   пользователем.
    def follow_flag_filter
      unless @personal
        @follow_flag = Microblog.where(:owner_id => current_user.id,
                                       :following_ids => @user.id).count != 0
      end
    end

    # Method: MicroblogController#get_followings_filter
    #
    # Description:
    #   Вытягивает из базы объект микроблога.
    #   Вытягиваются только счетчики подписки, и id пользователей, на кого
    #   подписан пользователь.
    def get_followings_filter
      @microblog = Microblog.where(:owner_id => @user.id).
                             only(:owner_id, :following_ids, 
                                  :followings_count, :followers_count,
                                  :posts_count, :recommends_count,
                                  :favorites_count).
                             first
    end

    # Method: MicroblogController#get_followers_filter
    #
    # Description:
    #   Вытягивает из базы объект микроблога.
    #   Вытягиваются только счетчики подписки, и id пользователей, кто
    #   подписан на пользователя.
    def get_followers_filter
      @microblog = Microblog.where(:owner_id => @user.id).
                             only(:owner_id, :follower_ids, 
                                  :followings_count, :followers_count,
                                  :posts_count, :recommends_count,
                                  :favorites_count).
                             first
    end

    # Method: MicroblogController#get_posts_count_filter
    #
    # Description:
    #   Вытягивает из базы объект микроблога.
    #   Вытягивается только счетчик постов пользователя.
    def get_posts_count_filter
      @microblog = Microblog.where(:owner_id => @user.id).
                             only(:owner_id, :posts_count,
                                  :followings_count, :followers_count,
                                  :recommends_count, :favorites_count).
                             first
    end

    #===========================================================================
    # Фильтры для сбора статистики
    #===========================================================================

    def top
      @top_actives = top_users(:posts_count)
      @top_followings = top_users(:followings_count)
      @top_followers = top_users(:followers_count)
    end

    def top_users(parameter)
      # Хэш микроблогов
      microblogs = Hash.new
      # Массив id активных пользователей
      actives = Array.new
      # Получаем id самых активных пользователей, и заполняем хэш микроблогов
      Microblog.all.
                desc(parameter).
                limit(10).
                only(parameter, :owner_id).
                each do |microblog|
        microblogs[microblog.owner_id] = microblog
        actives << microblog.owner_id
      end
      # Получаем самых активных пользователей и привязываем микроблоги
      User.ids(actives).only(:id, :username,
                             "user_profile.first_name", 
                             "user_profile.last_name",
                             "user_profile.avatar").
                        each do |user|
        microblogs[user.id].owner = user
      end
      microblogs.map { |m| m[1] }
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
      current_microblog = Microblog.owner_id(current_user.id).
                                    only(:following_ids).first
      users.each do |u|
        if u.id == current_user.id
          # Это текущий пользователь
          u.buffer = :self
        else
          if current_microblog.following?(u.id)
            # Текущий пользователь подписан на указанного
            u.buffer = :follow
          else
            # Текущий пользователь не подписан на указанного
            u.buffer = :unfollow
          end
        end
      end
    end

    # Method: MicroblogController#get_posts
    #
    # Description:
    #  Функция получает коллекцию постов, и если постов больше 0, получает
    #  информацию об авторах постов и прикрепляет к постам.
    #
    #  Умеет работать с will_paginate коллекциями.
    #  
    #  Это алгоритм оптимизации запроса, и решает следующие задачи:
    #    * Авторы вытягиваются одним запросом, а не многими, при обращении к
    #      каждому посту.
    #    * Один и тот же автор не вытягивается более одного раза.
    #    * Вытягивается только нужная информация об авторах, которая будет
    #      использована в шаблоне
    def get_posts(query)
      # Получаем paginate-коллекцию
      collection = query.paginate(:page => params[:page], :per_page => 20)
      # Определяем размер коллекции
      count = collection.size
      unless count == 0
        # Собираем id авторов постов
        author_ids = collection.map { |post| post.author_id }
        author_ids.uniq!
        # Собираем хэш авторов
        authors = Hash.new
        User.ids(author_ids).only(:id, :username, "user_profile.first_name",
                                  "user_profile.last_name", "user_profile.avatar").
                             each do |author|
          authors[author.id] = author
        end
        # Прикрепляем авторов к постам
        collection.each do |post|
          post.author = authors[post.author_id]
        end

        post_ids = collection.map { |post| post.id }

        # Собираем статус рекомендаций
        recommended_ids = MicroblogPost.where(:_id.in => post_ids, :recommend_ids => current_user.id).
                                        only(:id).
                                        map { |post| post.id }
        collection.each do |post|
          if recommended_ids.include?(post.id)
            post[:recommend] = true
          else
            post[:recommend] = false
          end
        end

        # Собираем статус понравившихся
        favorited_ids = MicroblogPost.where(:_id.in => post_ids, :favorite_ids => current_user.id).
                                        only(:id).
                                        map { |post| post.id }
        collection.each do |post|
          if favorited_ids.include?(post.id)
            post[:favorite] = true
          else
            post[:favorite] = false
          end
        end
      end
      return count, collection
    end

end
