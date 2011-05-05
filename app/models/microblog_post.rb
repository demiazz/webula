# -*- coding: utf-8 -*-

=begin

================================================================================

Class: MicroblogPost

Description:
  Модель поста микроблога.

  Модель хранит информацию о посте, а также список рекомендовавших этот пост,
  пользователей.

================================================================================

Поля:
  text              текст поста
  recommend_ids     id пользователей, которые рекомендовали пост
  recommends_count  число рекомендаций поста
  favorite_ids      id пользователей, которым понравился пост
  favorites_count   число пользователей, которым понравился пост

Связи:
  author            автор поста

Scopes:
  all_posts   все посты
  author_ids  поиск по id авторов
  author_id   поиск по конкретному автору

Методы документа:

================================================================================

Copyright (c) 2011, Alexey Plutalov <demiazz.py@gmail.com>

================================================================================

=end

class MicroblogPost
  include Mongoid::Document
  include Mongoid::Timestamps

  #=============================================================================
  # Поля модели
  #=============================================================================

  field :text, :type => String
  field :recommend_ids, :type => Array, :default => []
  field :recommends_count, :type => Integer, :default => 0
  field :favorite_ids, :type => Array, :default => []
  field :favorites_count, :type => Integer, :default => 0

  #=============================================================================
  # Связи
  #=============================================================================

  belongs_to :author, :class_name => "User", :inverse_of => :microblog_posts

  #=============================================================================
  # Scopes
  #=============================================================================

  scope :all_posts, all.desc(:created_at)
  scope :author_ids, ->(ids) { where(:author_id.in => ids).desc(:created_at) }
  scope :author_id, ->(id) { where(:author_id => id).desc(:created_at) }

  #== Ленты ====================================================================

end
