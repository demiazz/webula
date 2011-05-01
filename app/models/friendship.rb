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
  * owner  1 к 1 - имеет одного пользователя-владельца

Scopes:
  * owner_id  получить по id пользователя

Методы документа:
  * friends        друзья пользователя
  * requests_to    запросы от пользователей
  * requests_from  запросы к пользователям
  * friend?        этот пользователь в списке друзей?
  * request_to?    есть запрос от этого пользователя?
  * request_from?  есть запрос к этому пользователя?

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

  # Имеет одного хозяина
  belongs_to :owner, :class_name => "User", :inverse_of => :friendship

  #=============================================================================
  # Scopes
  #=============================================================================

  scope :owner_id, ->(id) { where(:owner_id => id) }

  #=============================================================================
  # Методы документа
  #=============================================================================

  # Method: Friendship#friends
  #
  # Description:
  #   Получение друзей пользователя.
  def friends
    User.ids(friend_ids)
  end

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

end
