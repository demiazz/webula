# -*- coding: utf-8 -*-

=begin

================================================================================

Class: Friendship

Description:
  Модель отношений дружбы. По другому: список друзей.

  Условно можно разделить на три списка друзей:
    * друзья (двусторонняя связь)
    * запросы на добавление в список друзей к пользователю владельцу
    * запросы на добавление в список друзей от пользователя владельца

================================================================================

Поля:
  * friend_ids           _id пользователей друзей
  * request_to_ids       _id пользователей, которые прислали запросы
  * request_from_ids     _id пользователей, которым отослали запросы
  * friends_count        число друзей
  * requests_to_count    число запросов к пользователю
  * requests_from_count  число запросов от пользователя

Связи:
  * owner                1 к 1 - имеет одного пользователя-владельца

Scopes:
  * owner_id             получить по id пользователя

Методы документа:
  * friends              друзья пользователя
  * requests_to          запросы от пользователей
  * requests_from        запросы к пользователям
  * mutual_friends       общие друзья с текущим пользователем
  * not_mutual_friends   не общие друзья с текущим пользователем
  * friend?              этот пользователь в списке друзей?
  * request_to?          есть запрос от этого пользователя?
  * request_from?        есть запрос к этому пользователя?
  * add_friend!          добавить пользователя в друзья
  * remove_friend!       удалить пользователя из друзей
  * add_request_to!      добавить запрос от пользователя
  * remove_request_to!   удалить запрос от пользователя
  * add_request_from!    добавить запрос к пользователю
  * remove_request_from! удалить запрос к пользователю

================================================================================

Copyright (c) 2011, Alexey Plutalov <demiazz.py@gmail.com>

================================================================================

=end

class Friendship
  include Mongoid::Document

  #=============================================================================
  # Поля модели
  #=============================================================================

  # _id друзей
  field :friend_ids, :type => Array, :default => []
  # _id пользователей, которые прислали запросы
  field :request_to_ids, :type => Array, :default => []
  # _id пользователей, которым отосланы запросы
  field :request_from_ids, :type => Array, :default => []
  # число друзей
  field :friends_count, :type => Integer, :default => 0
  # число присланных запросов
  field :requests_to_count, :type => Integer, :default => 0
  # число отосланных запросов
  field :requests_from_count, :type => Integer, :default => 0

  #=============================================================================
  # Связи
  #=============================================================================

  # имеет одного хозяина
  belongs_to :owner, :class_name => "User", :inverse_of => :friendship

  #=============================================================================
  # Scopes
  #=============================================================================

  scope :owner_id, ->(id) { where(:owner_id => id) }

  #=============================================================================
  # Методы документа
  #=============================================================================

  #== Списки друзей ============================================================

  # Method: Friendship#friends
  #
  # Description:
  #   Получение друзей пользователя.
  def friends
    User.ids(friend_ids)
  end

  # Method: Friendship#mutual_friends
  #
  # Description:
  #   Получение общих друзей.
  def mutual_friends
    if self.friends_count > 0
      current_friendship = Friendship.owner_id(current_user.id).
                                      only(:owner_id,
                                           :friend_ids,
                                           :friends_count)
      if current_friendship.friends_count > 0
        return User.ids(self.friend_ids & current_friendship.friend_ids)
      end
    end
    return User.all.limit(0)
  end

  # Method: Friendship#not_mutual_friends
  #
  # Description:
  #   Получение не общих друзей.
  def not_mutual_friends(id)
    if self.friends_count > 0
      current_friendship = Friendship.owner_id(current_user.id).
                                      only(:owner_id,
                                           :friend_ids,
                                           :friends_count)
      if current_friendship.friends_count > 0
        return User.ids(self.friend_ids - current_friendship.friend_ids -
                   [self.owner_id, current_friendship.owner_id])
      end
    end
    return User.all.limit(0)
  end

  #== Списки запросов ==========================================================

  # Method: Friendship#requests_to
  #
  # Description:
  #   Получение пользователей, приславших запрос.
  def requests_to
    User.ids(request_to_ids)
  end

  # Method: Friendship#requests_from
  #
  # Description:
  #   Получение пользователей, которым отослан запрос.
  def requests_from
    User.ids(request_from_ids)
  end

  #== Предикаты ================================================================

  # Method: Friendship#friend?
  #
  # Description:
  #   Этот пользователь в списке друзей?
  def friend?(id)
    friend_ids.include?(id)
  end

  # Method: Friendship#request_to?
  #
  # Description:
  #   Есть запрос от этого пользователя?
  def request_to?(id)
    request_to_ids.include?(id)
  end

  # Method: Friendship#request_from?
  #
  # Description:
  #   Есть запрос к этому пользователю?
  def request_from?(id)
    request_from_ids.include?(id)
  end

  #== Управление списком друзей ================================================

  # Method: Friendship#add_friend!
  #
  # Description:
  #   Добавить пользователя в список друзей.
  def add_friend!(id)
    unless self.friend?(id)
      self.friend_ids << id
    end
    self.friends_count = self.friend_ids.size
    self.save
  end

  # Method: Friendship#remove_friend!
  #
  # Description:
  #   Удалить пользователя из списка друзей.
  def remove_friend!(id)
    if self.friend?(id)
      self.friend_ids.delete(id)
    end
    self.friends_count = self.friend_ids.size
    self.save
  end

  #== Управление списком запросов от пользователя ==============================

  # Method: Friendship#add_request_to!
  #
  # Description:
  #   Добавить запрос к пользователю.
  def add_request_to!(id)
    unless self.request_to?(id)
      self.request_to_ids << id
    end
    self.requests_to_count = self.request_to_ids.size
    self.save
  end

  # Method: Friendship#remove_request_to!
  #
  # Description:
  #   Удалить запрос к пользователю.
  def remove_request_to!(id)
    if self.request_to?(id)
      self.request_to_ids.delete(id)
    end
    self.requests_to_count = self.request_to_ids.size
    self.save
  end

  #== Управление списком запросов к пользователю ===============================

  # Method: Friendship#add_request_from!
  #
  # Description:
  #   Добавить запрос от пользователя.
  def add_request_from!(id)
    unless self.request_from?(id)
      self.request_from_ids << id
    end
    self.requests_from_count = self.request_from_ids.size
    self.save
  end

  # Method: Friendship#remove_request_from!
  #
  # Description:
  #   Удалить запрос от пользователя.
  def remove_request_from!(id)
    if self.request_from?(id)
      self.request_from_ids.delete(id)
    end
    self.requests_from_count = self.request_from_ids.size
    self.save
  end

end
