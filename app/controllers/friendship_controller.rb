# -*- coding: utf-8 -*-

=begin

================================================================================

Class: FriendshipController

Description:
  Контроллер друзей.

  Позволяет просматривать и управлять отношениями пользователя.
  Для текущего пользователя предоставляется:
    * просмотр списка друзей
    * просмотр списка запросов на дружбу к пользователю
    * просмотр списка запросов на дружбу от пользователя
  Для не текущего пользователя предоставляется:
    * просмотр списка друзей
    * просмотр общих друзей
    * просмотр не общих друзей
  Для управления связями используется:
    * добавление пользователя в список друзей
    * удаление пользователя из списка друзей
    * подтверждение запроса на добавление в список друзей
    * отклонение запроса на добавление в список друзей

================================================================================

Actions:
  * index
  * requests_to
  * requests_from
  * show
  * mutual_friends
  * not_mutual_friends
  * add_friend
  * confirm_friend
  * refuse_friend
  * remove_friend

================================================================================

Copyright (c) 2011, Alexey Plutalov <demiazz.py@gmail.com>

================================================================================

=end

class FriendshipController < ApplicationController

  before_filter :current_stat, :only => [:index, :requests_to, :requests_from]
  before_filter :other_stat, :only => [:show, :mutual_friends, :not_mutual_friends]

  #=============================================================================
  # Списки друзей текущего пользователя
  #=============================================================================

  # Method: FriendshipController#index
  #
  # Description:
  #   Список друзей текущего пользователя.
  def index
    @friends = User.ids(current_user.friend_ids)
  end

  # Method: FriendshipController#requests_to
  #
  # Description:
  #   Список запросов на добавление в список друзей для текущего пользователя.
  def requests_to
    @requests = User.ids(current_user.requests_to_ids)
  end

  # Method: FriendshipController#requests_from
  #
  # Description:
  #   Список запросов на добавление в список друзей от текущего пользователя.
  def requests_from
    @requests = User.ids(current_user.requests_from_ids)
  end

  #=============================================================================
  # Списки друзей не текущего пользователя
  #=============================================================================

  # Method: FriendshipController#show
  #
  # Description:
  #   Список друзей указанного пользователя
  def show
    @friends = User.ids(@user.friend_ids)
  end

  # Method: FriendshipController#mutual_friends
  #
  # Description:
  #   Список общих друзей текущего и указанного пользователей.
  def mutual_friends
    unless @personal
      @friends = User.ids(current_user.friend_ids & @user.friend_ids)
    else
      redirect_to frienship__index_path
    end
  end

  # Method: FriendshipController#not_mutual_friends
  #
  # Description:
  #   Список не общих друзей текущего и указанного пользователей.
  def not_mutual_friends
    unless @personal
      @friends = User.ids(@user.friend_ids - current_user.friend_ids - [current_user.id, @user.id])
    else
      redirect_to friendship__index_path
    end
  end

  #=============================================================================
  # Управление списком друзей
  #=============================================================================

  # Method: FriendshipController#add_friend
  #
  # Description:
  #   Добавление пользователя в список друзей.
  #
  #   Стоит иметь ввиду, что на самом пользователь не добавляется в список друзей,
  #   а ему только отправляется запрос на добавление в список друзей, который
  #   он может подтвердить или отклонить, что повлечет за собой добавление его,
  #   или не добавление его в список друзей соответственно.
  def add_friend
    @friend = User.where(:username => params[:username]).first
    unless current_user.friend_ids.include?(@friend.id)
      unless current_user.requests_to_ids.include?(@friend.id)
        current_user.push(:requests_from_ids, @friend.id)
        @friend.push(:requests_to_ids, current_user.id)
        current_user.save
        @friend.save
      end
    end
    redirect_to :back
  end

  # Method: FriendshipController#confirm_friend
  #
  # Description:
  #   Подтверждение запроса на добавление в список друзей.
  def confirm_friend
    @friend = User.where(:username => params[:username]).first
    unless current_user.friend_ids.include?(@friend.id)
      if current_user.requests_to_ids.include?(@friend.id)
        current_user.pull_all(:requests_to_ids, [@friend.id])
        @friend.pull_all(:requests_from_ids, [current_user.id])
        current_user.push(:friend_ids, @friend.id)
        @friend.push(:friend_ids, current_user.id)
        current_user.save
        @friend.save
      end
    end
    redirect_to :back
  end

  # Method: FriendshipController#refuse_friend
  #
  # Description:
  #   Отклонение запроса на добавление в список друзей.
  def refuse_friend
    @friend = User.where(:username => params[:username]).first
    unless current_user.friend_ids.include?(@friend.id)
      if current_user.requests_to_ids.include?(@friend.id)
        current_user.pull_all(:requests_to_ids, [@friend.id])
        @friend.pull_all(:requests_from_ids, [current_user.id])
        current_user.save
        @friend.save
      end
    end
    redirect_to :back
  end

  # Method: FriendshipController#remove_friend
  #
  # Description:
  #   Удаление пользователя из списка друзей.
  #
  #   В отличии от добавления в список друзей, этот action в действительности
  #   удаляет пользователя из списка друзей.
  def remove_friend
    @friend = User.where(:username => params[:username]).first
    if current_user.friend_ids.include?(@friend.id)
      current_user.pull_all(:friend_ids, [@friend.id])
      @friend.pull_all(:friend_ids, [current_user.id])
      current_user.save
      @friend.save
    end
    redirect_to :back
  end

  protected

    #===========================================================================
    # Фильтры
    #===========================================================================

    # Method: FriendshipController#current_stat
    #
    # Description:
    #   Получение статистики текущего пользователя
    def current_stat
      @friends_count = current_user.friend_ids.size
      @requests_to_count = current_user.requests_to_ids.size
      @requests_from_count = current_user.requests_from_ids.size
    end

    # Method: FriendshipController#other_stat
    #
    # Description:
    #   Получение статистики указанного пользователя.
    def other_stat
      @friedns_count = @user.friend_ids.size
      @mutual_friends_count = (current_user.friend_ids & @user.friend_ids).size
      @not_mutual_friends_count = (@user.friend_ids - current_user.friend_ids - [current_user.id, @user.id]).size
    end

end
