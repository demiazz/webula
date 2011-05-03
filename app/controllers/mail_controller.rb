# -*- coding: utf-8 -*-

=begin

================================================================================

Class: MicroblogController

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

  #=============================================================================
  # Списки сообщений
  #=============================================================================

  # Method: Mail#inbox
  #
  # Description:
  #   Выводит список входящих сообщений.
  def inbox
    @messages = Message.recipient_id(@user.id).
                        paginate(:page => params[:page], :per_page => 20)
  end

  # Method: Mail#inbox_read
  #
  # Description:
  #   Выводит список входящих прочитанных сообщений.
  def inbox_read
    @messages = Message.recipient_id(@user.id).
                        status(true).
                        paginate(:page => params[:page], :per_page => 20)
  end

  # Method: Mail#inbox_unread
  #
  # Description:
  #   Выводит список входящих непрочитанных сообщений.
  def inbox_unread
    @messages = Message.recipient_id(@user.id).
                        status(false).
                        paginate(:page => params[:page], :per_page => 20)
  end

  # Method: Mail#outbox
  #
  # Description:
  #   Выводит список исходящих сообщений.
  def outbox
    @messages = Message.sender_id(@user.id).
                        paginate(:page => params[:page], :per_page => 20)
  end

  # Method: Mail#outbox_read
  #
  # Description:
  #   Выводит список исходящих прочитанных сообщений.
  def outbox_read
    @messages = Message.sender_id(@user.id).
                        status(true).
                        paginate(:page => params[:page], :per_page => 20)
  end

  # Method: Mail#outbox_unread
  #
  # Description:
  #   Выводит список исходящих непрочитанных сообщений.
  def outbox_unread
    @messages = Message.sender_id(@user.id).
                        status(false).
                        paginate(:page => params[:page], :per_page => 20)
  end

  #=============================================================================
  # Просмотр сообщений
  #=============================================================================

  # Method: Mail#show_inbox_message
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
      end
    end
  end

  # Method: Mail#show_outbox_message
  #
  # Description:
  #   Показать исходящее сообщение.
  def show_outbox_message
    @message = Message.id(params[:id]).sender_id(@user.id).first
  end

  #=============================================================================
  # История переписки с пользователем
  #=============================================================================

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

  def create_message
    if @recipient = User.where(:_id => params[:message][:recipient_id]).exists?
      @message = Message.new
      @message.recipient_id = params[:message][:recipient_id]
      @message.sender_id = @user.id
      @message.subject = params[:message][:subject]
      @message.text = params[:message][:text]
      @message.status = false
      @message.save
    end
    redirect_to mail__show_outbox_message_path(:id => @message.id)
  end

  def delete_message
    @message = Message.id(params[:id]).recipient_id(@user.id).first
    unless @message.nil?
      @message.destroy
    end
    redirect_to mail__inbox_path
  end

end
