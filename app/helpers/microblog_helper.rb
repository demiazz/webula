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

end
