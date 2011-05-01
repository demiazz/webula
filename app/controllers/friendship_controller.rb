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

  #=============================================================================
  # Списки друзей
  #=============================================================================

  # Method: Friendship#friends
  #
  # Description:
  #   Список друзей.
  def friends
    @friendship = Friendship.owner_id(@user.id).
                             only(:friend_ids,
                                  :friends_count,
                                  :requests_to_count,
                                  :requests_from_count).
                             first
    @friends_count = @friendship.friends_count
    @requests_to_count = @friendship.requests_to_count
    @requests_from_count = @friendship.requests_from_count
    if @friends_count > 0
      @friends = @friendship.friends.only(:id, "user_profile.first_name",
                                          "user_profile.last_name",
                                          "user_profile.org_name",
                                          "user_profile.org_unit",
                                          "user_profile.org_position")
    end
  end

  # Method: Friendship#requests_to
  #
  # Description:
  #   Список запросов к пользователю.
  def requests_to
    if @personal
      @friendship = Friendship.owner_id(@user.id).
                               only(:request_to_ids,
                                    :friends_count,
                                    :requests_to_count,
                                    :requests_from_count).
                               first
      @friends_count = @friendship.friends_count
      @requests_to_count = @friendship.requests_to_count
      @requests_from_count = @friendship.requests_from_count
      if @requests_to_count > 0
        @requests = @friendship.requests_to.only(:id, "user_profile.first_name",
                                                 "user_profile.last_name",
                                                 "user_profile.org_name",
                                                 "user_profile.org_unit",
                                                 "user_profile.org_position")
      end
    else
      redirect_to friendship__index_path
    end
  end

  # Method: Friendship#requests_from
  #
  # Description:
  #   Список запросов от пользователя.
  def requests_from
    if @personal
      @friendship = Friendship.owner_id(@user.id).
                               only(:request_from_ids,
                                    :friends_count,
                                    :requests_to_count,
                                    :requests_from_count).
                               first
      @friends_count = @friendship.friends_count
      @requests_to_count = @friendship.requests_to_count
      @requests_from_count = @friendship.requests_from_count
      if @requests_from_count > 0
        @requests = @friendship.requests_from.only(:id, "user_profile.first_name",
                                                   "user_profile.last_name",
                                                   "user_profile.org_name",
                                                   "user_profile.org_unit",
                                                   "user_profile.org_position")
      end
    else
      redirect_to friendship__index_path
    end
  end

  # Method: Friendship#mutual_friends
  #
  # Description:
  #   Список общих друзей с текущим пользователем.
  def mutual_friends
    unless @personal
      @friendship = Friendship.owner_id(@user.id).
                               only(:friend_ids,
                                    :friends_count,
                                    :requests_to_count,
                                    :requests_from_count).
                               first
      @friends_count = @friendship.friends_count
      @requests_to_count = @friendship.requests_to_count
      @requests_from_count = @friendship.requests_from_count
      if @friends_count > 0
        @friends = @friendship.not_mutual_friends.only(:id, "user_profile.first_name",
                                                       "user_profile.last_name",
                                                       "user_profile.org_name",
                                                       "user_profile.org_unit",
                                                       "user_profile.org_position")
        @not_mutual_friends_count = @friends.count
      end
    else
      redirect_to friendship__index_path
    end
  end

  # Method: Friendship#not_mutual_friends
  #
  # Description:
  #   Список не общих друзей с текущим пользователем.
  def not_mutual_friends
    unless @personal
      @friendship = Friendship.owner_id(@user.id).
                               only(:friend_ids,
                                    :friends_count,
                                    :requests_to_count,
                                    :requests_from_count).
                               first
      @friends_count = @friendship.friends_count
      @requests_to_count = @friendship.requests_to_count
      @requests_from_count = @friendship.requests_from_count
      if @friends_count > 0
        @friends = @friendship.mutual_friends.only(:id, "user_profile.first_name",
                                                   "user_profile.last_name",
                                                   "user_profile.org_name",
                                                   "user_profile.org_unit",
                                                   "user_profile.org_position")
        @mutual_friends_count = @friends.count
      end
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
    @friendship = Friendship.owner_id(@user.id).
                             only(:request_to_ids,
                                  :requests_to_count).
                             first
    @friend = User.where(:username => params[:friend]).
                   only(:id).
                   first
    @friend_friendship = Friendship.owner_id(@friend.id).
                                    only(:request_from_ids,
                                         :requests_from_count)
    @friendship.add_request_to!(@friend.id)
    @friend_friendship.add_request_from!(@user.id)
    redirect_to :back
  end

  # Method: FriendshipController#confirm_friend
  #
  # Description:
  #   Подтверждение запроса на добавление в список друзей.
  def confirm_friend
    @friendship = Friendship.owner_id(@user.id).
                             only(:friend_ids,
                                  :request_from_ids,
                                  :friends_count,
                                  :requests_from_count).
                             first
    @friend = User.where(:username => params[:friend]).
                   only(:id).
                   first
    @friend_friendship = Friendship.owner_id(@friend.id).
                                    only(:friend_ids,
                                         :request_to_ids,
                                         :friends_count,
                                         :requests_to_count)
    @friendship.remove_request_from!(@friend.id)
    @friendship.add_friend!(@friend.id)
    @friend_friendship.remove_request_to!(@friend.id)
    @friend_friendship.add_friend!(@friend.id)
    redirect_to :back
  end

  # Method: FriendshipController#refuse_friend
  #
  # Description:
  #   Отклонение запроса на добавление в список друзей.
  def refuse_friend
    @friendship = Friendship.owner_id(@user.id).
                             only(:request_from_ids,
                                  :requests_from_count).
                             first
    @friend = User.where(:username => params[:friend]).
                   only(:id).
                   first
    @friend_friendship = Friendship.owner_id(@friend.id).
                                    only(:request_to_ids,
                                         :requests_to_count)
    @friendship.remove_request_from!(@friend.id)
    @friend_friendship.remove_request_to!(@friend.id)
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
    @friendship = Friendship.owner_id(@user.id).
                             only(:friend_ids,
                                  :friends_count).
                             first
    @friend = User.where(:username => params[:friend]).
                   only(:id).
                   first
    @friend_friendship = Friendship.owner_id(@friend.id).
                                    only(:friend_ids,
                                         :friends_count)
    @friendship.remove_friend!(@friend.id)
    @friend_friendship.remove_friend!(@friend.id)
    redirect_to :back
  end

end
