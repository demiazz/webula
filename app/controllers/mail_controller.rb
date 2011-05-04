# -*- coding: utf-8 -*-

=begin

================================================================================

Class: MailController

Description:
  Контроллер почтовых сообщений.

================================================================================

Actions:
  * inbox
  * outbox

================================================================================

Copyright (c) 2011, Alexey Plutalov <demiazz.py@gmail.com>

================================================================================

=end

class MailController < ApplicationController

  before_filter :get_mail

  #=============================================================================
  # Списки сообщений
  #=============================================================================

  # Method: MailController#inbox
  #
  # Description:
  #   Выводит список входящих сообщений.
  def inbox
    @messages_count,
    @messages = get_messages(@user.inbox_messages, true, false)
  end

  # Method: MailController#inbox_read
  #
  # Description:
  #   Выводит список входящих прочитанных сообщений.
  def inbox_read
    @messages_count,
    @messages = get_messages(@user.inbox_messages.status(true), true, false)
  end

  # Method: MailController#inbox_unread
  #
  # Description:
  #   Выводит список входящих непрочитанных сообщений.
  def inbox_unread
    @messages_count,
    @messages = get_messages(@user.inbox_messages.status(false), true, false)
  end

  # Method: MailController#outbox
  #
  # Description:
  #   Выводит список исходящих сообщений.
  def outbox
    @messages_count,
    @messages = get_messages(@user.outbox_messages, false, true)
  end

  # Method: MailController#outbox_read
  #
  # Description:
  #   Выводит список исходящих прочитанных сообщений.
  def outbox_read
    @messages_count,
    @messages = get_messages(@user.outbox_messages.status(true), false, true)
  end

  # Method: MailController#outbox_unread
  #
  # Description:
  #   Выводит список исходящих непрочитанных сообщений.
  def outbox_unread
    @messages_count,
    @messages = get_messages(@user.outbox_messages.status(false), false, true)
  end

  #=============================================================================
  # Просмотр сообщений
  #=============================================================================

  # Method: MailController#show_inbox_message
  #
  # Description:
  #   Показать входящее сообщение.
  def show_inbox_message
    @message = Message.id(params[:id]).recipient_id(@user.id).first
    unless @message.nil?
      @new_message = Message.new
      @new_message.recipient_id = @message.sender_id
      @new_message.subject = @message.subject 
      
      unless @message.status
        @message.status = true
        @message.save
        
        @mail.inbox_unread_count -= 1
        @mail.inbox_read_ccount += 1
        @mail.save

        @other_mail = Mail.owner_id(@message.sender_id)
        @other_mail.outbox_unread_count -= 1
        @other_mail.outbox_read_count += 1
        @other_mail.save
      end
    end
  end

  # Method: MailController#show_outbox_message
  #
  # Description:
  #   Показать исходящее сообщение.
  def show_outbox_message
    @message = Message.id(params[:id]).sender_id(@user.id).first
  end

  #=============================================================================
  # История переписки с пользователем
  #=============================================================================

  # Method: MailController
  #
  # Description:
  #   История переписки с пользователем.
  def history
    @other = User.username(params[:other_username]).
                  only(:id, :username, "user_profile.first_name",
                       "user_profile.last_name", "user_profile.avatar").
                  first
    unless @other.nil?
      @messages = Message.history(@user.id, @other.id).
                          paginate(:page => params[:page], :per_page => 20)
    else
      # TODO: Куда редиректить, если такого пользователя нет?
    end
  end

  #=============================================================================
  # Управление сообщениями
  #=============================================================================

  # Method: MailController#new_message
  #
  # Description:
  #   Форма нового сообщения.
  def new_message
    @other = User.username(params[:for]).
                  only(:id, :username, "user_profile.first_name",
                       "user_profile.last_name", "user_profile.avatar").
                  first
    unless @other.nil?
      @message = Message.new
      @message.recipient_id = @other.id
    else
      # TODO: Куда редиректить, если такого пользователя нет?
    end
  end

  # Method: MailController#create_message
  #
  # Description:
  #   Создание сообщения.
  def create_message
    if @recipient = User.where(:_id => params[:message][:recipient_id]).exists?
      @message = Message.new
      @message.recipient_id = params[:message][:recipient_id]
      @message.sender_id = @user.id
      @message.subject = params[:message][:subject]
      @message.text = params[:message][:text]
      @message.status = false
      @message.save

      @mail.outbox_count += 1
      @mail.outbox_unread += 1
      @mail.save

      @other_mail = Mail.owner_id(params[:recipient_id])
      @other_mail.inbox_count += 1
      @other_mail.inbox_unread += 1
      @other_mail.save
    end
    redirect_to mail__show_outbox_message_path(:id => @message.id)
  end

  # Method: MailController#delete_message
  #
  # Description:
  #   Удаление сообщения.
  def delete_message
    @message = Message.id(params[:id]).recipient_id(@user.id).first
    unless @message.nil?
      status = @message.status
      sender_id = @message.sender_id
      
      @message.destroy

      @mail.inbox_count -= 1
      if status
        @mail.inbox_read_count -= 1
      else
        @mail.inbox_unread_count -= 1
      end
      @mail.save

      @other_mail = Mail.owner_id(sender_id)
      @other_mail.outbox_count -= 1
      if status
        @other_mail.outbox_read_count -= 1
      else
        @other_mail.outbox_unread_count -= 1
      end
      @other_mail.save
    end
    redirect_to mail__inbox_path
  end

  protected

  #=============================================================================
  # Фильтры
  #=============================================================================

  protected

    # Method: MailController#get_mail
    #
    # Description:
    #   Получение почтовой статистики.
    def get_mail
      @mail = Mail.owner_id(@user.id)
    end

  #=============================================================================
  # Внутренние функции
  #=============================================================================

  private

    # Method: MailController#get_messages
    #
    # Description:
    #   Получение сообщений с pagination, и буферизованными получателем и 
    #   отправителем.
    def get_messages(query, sender=true, recipient=true)
      # Получаем paginate-коллекцию
      collection = query.paginate(:page => params[:page], :per_page => 20)
      # Определяем размер коллекции
      count = collection.size
      unless count == 0
        # Буферизация отправителя
        if sender
          # Собираем id отправителей сообщений
          sender_ids = collection.map { |message| message.sender_id }
          sender_ids.uniq!
          # Собираем хэш отправителей
          senders = Hash.new
          User.ids(sender_ids).only(:id, :username, "user_profile.first_name",
                                    "user_profile.last_name", "user_profile.avatar").
                             each do |sender|
            senders[sender.id] = sender
          end
          # Прикрепляем отправителей к сообщениям
          collection.each do |message|
            message.sender = senders[message.sender_id]
          end
        else
          collection.each do |message|
            message.sender = sender
          end
        end
        # Буферизация получателя
        if recipient
          # Собираем id получателей сообщений
          recipient_ids = collection.map { |message| message.recipient_id }
          recipient_ids.uniq!
          # Собираем хэш получателей
          recipients = Hash.new
          User.ids(recipient_ids).only(:id, :username, "user_profile.first_name",
                                        "user_profile.last_name", "user_profile.avatar").
                             each do |recipient|
            recipients[recipient.id] = recipient
          end
          # Прикрепляем получателей к сообщениям
          collection.each do |message|
            message.recipient = recipients[message.recipient_id]
          end
        else
          collection.each do |message|
            message.recipient = recipient
          end
        end
      end
      return count, collection
    end

end
