# -*- coding: utf-8 -*-

=begin

================================================================================

Class: Microblog

Description:
  Модель хранения микроблога пользователя.

  Позволяет:
    * управлять подписками пользователя
    * кэшировать информацию о микроблоге пользователя

================================================================================

Поля:
  * following_ids       _id пользователей, на кого подписан
  * follower_ids        _id пользователей, кто подписан
  * followings_count    число пользователей, на кого подписан
  * followers_count     число пользователей, кто подписан
  * posts_count         число постов
  * recommends_count    число рекомендованных постов

Связи:
  * owner               1 к 1 - имеет одного владельца

Scopes:
  * owner_id            получить по id владельца

Методы документа:
  * followings          список пользователей, на кого подписан
  * followers           список пользователей, кто подписан
  * following?          подписан на пользователя?
  * follower?           пользователь подписан?
  * add_following!      добавить пользователя, в список на кого подписан
  * remove_following!   удалить пользователя, из списка на кого подписан
  * add_follower!       добавить пользователя, в список кто подписан
  * remove_follower!    удалить пользователя, из списка кто подписан

================================================================================

Copyright (c) 2011, Alexey Plutalov <demiazz.py@gmail.com>

================================================================================

=end

class Microblog
  include Mongoid::Document

  #=============================================================================
  # Поля модели
  #=============================================================================

  # пользователи, которых читает пользователь по id
  field :following_ids, :type => Array, :default => []
  # читатели пользователя по id
  field :follower_ids, :type => Array, :default => []
  # число пользователей, которых пользователь читает
  field :followings_count, :type => Integer, :default => 0
  # число читателей пользователя
  field :followers_count, :type => Integer, :default => 0
  # количество постов пользователя
  field :posts_count, :type => Integer, :default => 0
  # количество рекомендованных постов
  field :recommends_count, :type => Integer, :default => 0

  #=============================================================================
  # Связи
  #=============================================================================

  # имеет одного хозяина
  belongs_to :owner, :class_name => "User", :inverse_of => :microblog

  #=============================================================================
  # Scopes
  #=============================================================================

  scope :owner_id, ->(id) { where(:owner_id => id) }

  #=============================================================================
  # Методы документа
  #=============================================================================

  #== Списки подписки ==========================================================

  # Method: Microblog#followings
  #
  # Description:
  #   Список пользователей, на кого подписан.
  def followings
    User.ids(following_ids)
  end

  # Method: Microblog#followers
  #
  # Description:
  #   Список пользователей, кто подписан.
  def followers
    User.ids(follower_ids)
  end

  #== Предикаты ================================================================

  # Method: Microblog#following?
  #
  # Description:
  #   В списке, на кого подписан?
  def following?(id)
    following_ids.include?(id)
  end

  # Method: Microblog#follower?
  #
  # Description:
  #   В списке, кто подписан?
  def follower?(id)
    follower_ids.include?(id)
  end

  #== Управление списком подписок ==============================================

  # Method: Microblog#add_following!
  #
  # Description:
  #   Добавить в список, на кого подписан.
  def add_following!(id)
    unless self.following?(id)
      self.following_ids << id
    end
    self.followings_count = self.following_ids.size
    self.save
  end

  # Method: Microblog#remove_following!
  #
  # Description:
  #   Удалить из списка, на кого подписан.
  def remove_following!(id)
    if self.following?(id)
      self.following_ids.delete(id)
    end
    self.followings_count = self.following_ids.size
    self.save
  end

  # Method: Microblog#add_follower!
  #
  # Description:
  #   Добавить в список, кто подписан.
  def add_follower!(id)
    unless self.follower?(id)
      self.follower_ids << id
    end
    self.followers_count = self.follower_ids.size
    self.save
  end

  # Method: Microblog#remove_follower!
  #
  # Description:
  #   Удалить из списка, на кого подписан.
  def remove_follower!(id)
    if self.follower?(id)
      self.follower_ids.delete(id)
    end
    self.followers_count = self.follower_ids.size
    self.save
  end

end
