class ApplicationController < ActionController::Base

  protect_from_forgery

  before_filter :authenticate_user!
  before_filter :profile

  private

    def profile
      if user_signed_in?
        if current_user.user_profile.new_profile
          redirect_to :controller => "profile_master", :action => "main_edit"
        end
      end
    end

end
