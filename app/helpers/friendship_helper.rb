module FriendshipHelper

  def to_friends(name="Friends", html_options={})
    if action_name == "friends"
      html_options[:class] = html_options[:class].nil? ?
                               "selected" :
                               html_options[:class].concat(" selected")
    end
    link_to name, friendship__friends_path(:username => nil), html_options
  end

  def to_user_friends(user, name="Friends", html_options={})
    if action_name == "friends"
      html_options[:class] = html_options[:class].nil? ?
                               "selected" :
                               html_options[:class].concat(" selected")
    end
    username = user.nil? ? nil : user.username
    link_to name, friendship__friends_path(:username => username), html_options
  end

  def to_requests_to(name="Requests for you", html_options={})
    if action_name == "requests_to"
      html_options[:class] = html_options[:class].nil? ?
                               "selected" :
                               html_options[:class].concat(" selected")
    end
    link_to name, friendship__requests_to_path, html_options
  end

  def to_requests_from(name="Your requests", html_options={})
    if action_name == "requests_from"
      html_options[:class] = html_options[:class].nil? ?
                               "selected" :
                               html_options[:class].concat(" selected")
    end
    link_to name, friendship__requests_from_path, html_options
  end

  def to_friends_home(name="Friends", html_options={})
    to_friends(nil, name, html_options)
  end

end
