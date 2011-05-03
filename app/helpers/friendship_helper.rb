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
    link_to name, friendship__friends_path(:username => user.username), html_options
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

  def to_mutual_friends(user, name="Mutual friends", html_options={})
    if action_name == "mutual_friends"
      html_options[:class] = html_options[:class].nil? ?
                               "selected" :
                               html_options[:class].concat(" selected")
    end
    link_to name, friendship__mutual_friends_path(:username => user.username), html_options
  end

  def to_not_mutual_friends(user, name="Not mutual friends", html_options={})
    if action_name == "not_mutual_friends"
      html_options[:class] = html_options[:class].nil? ?
                               "selected" :
                               html_options[:class].concat(" selected")
    end
    link_to name, friendship__not_mutual_friends_path(:username => user.username), html_options
  end

  def to_add_friend(user, name="Add to friends", html_options={})
    html_options[:class] = html_options[:class].nil? ?
                             "constructive" :
                             html_options[:class].concat(" destructive")
    html_options[:method] = :put
    link_to name, friendship__add_friend_path(:friend => user.username), html_options
  end

  def to_confirm_friend(user, name="Confirm request", html_options={})
    html_options[:class] = html_options[:class].nil? ?
                             "constructive" :
                             html_options[:class].concat(" destructive")
    html_options[:method] = :put
    link_to name, friendship__confirm_friend_path(:friend => user.username), html_options
  end

  def to_refuse_friend(user, name="Refuse request", html_options={})
    html_options[:class] = html_options[:class].nil? ?
                             "destructive" :
                             html_options[:class].concat(" destructive")
    html_options[:method] = :put
    link_to name, friendship__refuse_friend_path(:friend => user.username), html_options
  end

  def to_remove_friend(user, name="Remove from friends", html_options={})
    html_options[:class] = html_options[:class].nil? ?
                             "destructive" :
                             html_options[:class].concat(" destructive")
    html_options[:method] = :put
    link_to name, friendship__remove_friend_path(:friend => user.username), html_options
  end

  def to_friends_home(name="Friends", html_options={})
    to_friends(nil, name, html_options)
  end

end
