module MicroblogHelper

  def to_microblog_home(name="Microblog", html_options = {})
    link_to name, url_for(:controller => "microblog",
                          :action => "local_feed",
                          :username => nil), html_options
  end

  def to_microblog_user_home(user, name="Microblog", html_options = {})
    link_to name, url_for(:controller => "microblog",
                          :action => "personal_feed",
                          :username => user.username), html_options
  end

  def to_microblog_global_feed(name="Global", html_options = {})
    link_to name, url_for(:controller => "microblog",
                          :action => "global_feed",
                          :username => nil), html_options
  end

  def to_microblog_local_feed(name="Local", html_options = {})
    link_to name, url_for(:controller => "microblog",
                          :action => "local_feed",
                          :username => nil), html_options
  end

  def to_microblog_personal_feed(name="Personal", html_options = {})
    link_to name, url_for(:controller => "microblog",
                          :action => "personal_feed",
                          :username => nil), html_options
  end

  def to_microblog_followings_feed(name="Followings", html_options = {})
    link_to name, url_for(:controller => "microblog",
                          :action => "followings_feed",
                          :username => nil), html_options
  end

  def to_microblog_followers_feed(name="Followers", html_options = {})
    link_to name, url_for(:controller => "microblog",
                          :action => "followers_feed",
                          :username => nil), html_options
  end

  def to_microblog_user_local_feed(user, name="Local", html_options = {})
    link_to name, url_for(:controller => "microblog",
                          :action => "local_feed",
                          :username => user.username), html_options
  end

  def to_microblog_user_personal_feed(user, name="Personal", html_options = {})
    link_to name, url_for(:controller => "microblog",
                          :action => "personal_feed",
                          :username => user.username), html_options
  end

  def to_microblog_user_followings_feed(user, name="Followings", html_options = {})
    link_to name, url_for(:controller => "microblog",
                          :action => "followings_feed",
                          :username => user.username), html_options
  end

  def to_microblog_user_followers_feed(user, name="Followers", html_options = {})
    link_to name, url_for(:controller => "microblog",
                          :action => "followers_feed",
                          :username => user.username), html_options
  end

  def to_microblog_subscribes(name="Subscribes", html_options = {})
    link_to name, url_for(:controller => "microblog",
                          :action => "followings",
                          :username => nil), html_options
  end

  def to_microblog_user_subscribes(user, name="Subscribes", html_options = {})
    link_to name, url_for(:controller => "microblog",
                          :action => "followings",
                          :username => user.username), html_options
  end

  def to_microblog_followings(name="Followings", html_options = {})
    link_to name, url_for(:controller => "microblog",
                          :action => "followers",
                          :username => nil), html_options
  end

  def to_microblog_followers(name="Followers", html_options = {})
    link_to name, url_for(:controller => "microblog",
                          :action => "followers",
                          :username => nil), html_options
  end

  def to_microblog_user_followings(user, name="Followers", html_options = {})
    link_to name, url_for(:controller => "microblog",
                          :action => "followings_feed",
                          :username => user.username), html_options
  end
  def to_microblog_user_followers(user, name="Followers", html_options = {})
    link_to name, url_for(:controller => "microblog",
                          :action => "followers_feed",
                          :username => user.username), html_options
  end

end
