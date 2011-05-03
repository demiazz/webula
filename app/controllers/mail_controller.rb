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

end
