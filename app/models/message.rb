# -*- coding: utf-8 -*-

=begin

================================================================================

Class: Message

Description:
  Модель почтового сообщения.

================================================================================

Поля:
  * subject  тема сообщения
  * text     текст сообщения
  * status   статус сообщения

================================================================================

Copyright (c) 2011, Alexey Plutalov <demiazz.py@gmail.com>

================================================================================

=end

class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  #=============================================================================
  # Поля модели
  #=============================================================================

  # тема сообщения
  field :subject, :type => String, :default => ""
  # текст сообщения
  field :text, :type => String, :default => ""
  # статус сообщения
  field :status, :type => Boolean, :default => false

  #=============================================================================
  # Связи
  #=============================================================================

  belongs_to :sender, :class_name => "User", :inverse_of => :outbox_messages
  belongs_to :recipient, :class_name => "User", :inverse_of => :inbox_messages

  #=============================================================================
  # Scopes
  #=============================================================================

  scope :id, ->(id) { where(:_id => id) }
  scope :sender_id, ->(id) { where(:sender_id => id) }
  scope :recipient_id, ->(id) { where(:recipient_id => id) }
  scope :status, ->(st) { where(:status => st) }
  scope :history, ->(first_id, second_id) { any_of({
                                                    :recipient_id => first_id,
                                                    :sender_id => second_id
                                                   },
                                                   {
                                                    :recipient_id => second_id,
                                                    :sender_id => first_id
                                                   }) }

end
