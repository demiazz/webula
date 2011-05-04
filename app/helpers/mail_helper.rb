module MailHelper

  def to_mail_inbox(name="Inbox(all)", html_options={})
    if action_name == "inbox"
      html_options[:class] = html_options[:class].nil? ?
                               "selected" :
                               html_options[:class].concat(" selected")
    end
    link_to name, mail__inbox_path, html_options
  end

  def to_mail_inbox_read(name="Inbox(read)", html_options={})
    if action_name == "inbox_read"
      html_options[:class] = html_options[:class].nil? ?
                               "selected" :
                               html_options[:class].concat(" selected")
    end
    link_to name, mail__inbox_read_path, html_options
  end

  def to_mail_inbox_unread(name="Inbox(unread)", html_options={})
    if action_name == "inbox_unread"
      html_options[:class] = html_options[:class].nil? ?
                               "selected" :
                               html_options[:class].concat(" selected")
    end
    link_to name, mail__inbox_unread_path, html_options
  end

  def to_mail_outbox(name="Outbox(all)", html_options={})
    if action_name == "outbox"
      html_options[:class] = html_options[:class].nil? ?
                               "selected" :
                               html_options[:class].concat(" selected")
    end
    link_to name, mail__outbox_path, html_options
  end

  def to_mail_outbox_read(name="Outbox(read)", html_options={})
    if action_name == "outbox_read"
      html_options[:class] = html_options[:class].nil? ?
                               "selected" :
                               html_options[:class].concat(" selected")
    end
    link_to name, mail__outbox_read_path, html_options
  end

  def to_mail_outbox_unread(name="Outbox(unread)", html_options={})
    if action_name == "outbox_unread"
      html_options[:class] = html_options[:class].nil? ?
                               "selected" :
                               html_options[:class].concat(" selected")
    end
    link_to name, mail__outbox_unread_path, html_options
  end

  def to_mail_history(user, name="Message History", html_options={})
    link_to name, mail__history_path(:other_username => user.username), html_options
  end

  def to_mail_show_inbox_message(message, name="Show message", html_options={})
    link_to name, mail__show_inbox_message_path(:id => message.id), html_options
  end

  def to_mail_show_outbox_message(message, name="Show message", html_options={})
    link_to name, mail__show_outbox_message_path(:id => message.id), html_options
  end

  def to_mail_new_message(user, name="New message", html_options={})
    link_to name, mail__new_message_path(:for => user.username), html_options
  end

  def to_mail_create_message(name="Create message", html_options={})
    html_options[:class] = html_options[:class].nil? ?
                             "constructive" :
                             html_options[:class].concat(" constructive")
    html_options[:method] = :put
    link_to name, mail__create_message_path, html_options
  end

  def to_mail_delete_message(message, name="Delete message", html_options={})
    html_options[:class] = html_options[:class].nil? ?
                             "destructive" :
                             html_options[:class].concat(" constructive")
    html_options[:method] = :delete
    link_to name, mail__delete_message_path(message.id), html_options
  end

end
