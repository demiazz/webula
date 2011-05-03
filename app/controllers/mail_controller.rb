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

  def inbox
    @messages_count = Message.where(:recipient_id => @user.id).count
    if @messages_count > 0
      @messages = Message.where(:recipient_id => @user.id)
    end
  end

  def outbox
    @messages_count = Message.where(:sender_id => @user.id).count
    if @messages_count > 0
      @messages = Message.where(:sender_id => @user.id)
    end
  end

end
