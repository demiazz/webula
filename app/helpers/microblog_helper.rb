module MicroblogHelper

  def MicroblogHelper.included(mod)
    %w[global local personal followings followers].each do |feed|
      pattern = "
        def to_microblog_#{feed}_feed(name=\"#{feed.capitalize}\", html_options = {})
          if action_name == \"#{feed}_feed\"
            html_options[:class] = html_options[:class].nil? ?
                                     \"selected\" :
                                     html_options[:class].concat(\" selected\")
          end
          link_to name, url_for(:controller => \"microblog\",
                                :action => \"#{feed}_feed\",
                                :username => nil), html_options
        end"
      mod.module_eval pattern
    end
    %w{local personal followings followers}.each do |feed|
      pattern = "
        def to_microblog_user_#{feed}_feed(user, name=\"#{feed.capitalize}\", html_options = {})
          if action_name == \"#{feed}_feed\"
            html_options[:class] = html_options[:class].nil? ?
                                     \"selected\" :
                                     html_options[:class].concat(\" selected\")
          end
          link_to name, url_for(:controller => \"microblog\",
                                :action => \"#{feed}_feed\",
                                :username => user.username), html_options
        end"
      mod.module_eval pattern
    end
    %w{followings followers}.each do |subscribes|
      pattern = "
        def to_microblog_#{subscribes}(name=\"#{subscribes.capitalize}\", html_options = {})
          if action_name == \"#{subscribes}\"
            html_options[:class] = html_options[:class].nil? ?
                                     \"selected\" :
                                     html_options[:class].concat(\" selected\")
          end
          link_to name, url_for(:controller => \"microblog\",
                                :action => \"#{subscribes}\",
                                :username => nil), html_options
        end"
      mod.module_eval pattern
      pattern = "
        def to_microblog_user_#{subscribes}(user, name=\"#{subscribes.capitalize}\", html_options = {})
          if action_name == \"#{subscribes}\"
            html_options[:class] = html_options[:class].nil? ?
                                     \"selected\" :
                                     html_options[:class].concat(\" selected\")
          end
          link_to name, url_for(:controller => \"microblog\",
                                :action => \"#{subscribes}\",
                                :username => user.username), html_options
        end"
      mod.module_eval pattern
    end
  end

  def to_microblog_home(name="Microblog", html_options = {})
    to_microblog_local_feed(name, html_options)
  end

  def to_microblog_user_home(user, name="Microblog", html_options = {})
    to_microblog_user_personal_feed(user, name, html_options)
  end

  def to_microblog_subscribes(name="Subscribes", html_options = {})
    to_microblog_followings(name, html_options)
  end

  def to_microblog_user_subscribes(user, name="Subscribes", html_options = {})
    to_microblog_user_followings(user, name, html_options)
  end

  def to_follow(user, name="Follow", html_options = {})
    html_options[:class] = html_options[:class].nil? ?
                             "constructive" :
                             html_options[:class].concat(" constructive")
    html_options[:method] = :put
    link_to name, url_for(:controller => "microblog",
                          :action => "add_following",
                          :following => user.username), html_options
  end

  def to_unfollow(user, name="Unfollow", html_options = {})
    html_options[:class] = html_options[:class].nil? ?
                             "destructive" :
                             html_options[:class].concat(" destructive")
    html_options[:method] = :put
    link_to name, url_for(:controller => "microblog",
                          :action => "remove_following",
                          :following => user.username), html_options
  end

  def to_delete_post(post, name="Delete post", html_options = {})
    html_options[:class] = html_options[:class].nil? ?
                             "destructive" :
                             html_options[:class].concat(" destructive")
    html_options[:method] = :put
    link_to name, url_for(:controller => "microblog",
                          :action => "delete_post",
                          :id => post.id), html_options
  end

end
