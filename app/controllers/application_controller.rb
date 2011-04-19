class ApplicationController < ActionController::Base

  protect_from_forgery

  before_filter :authenticate_user!
  before_filter :profile
  before_filter :personalize

  private

    def profile
      if user_signed_in?
        if current_user.user_profile.new_profile
          redirect_to :controller => "profile_master", :action => "main_edit"
        end
      end
    end

    def personalize
      if user_signed_in?
        if params[:username].nil?
          @user = current_user
        else
          @user = User.first(conditions: { username: params[:username] })
        end
        @user_profile = @user.user_profile
      end
    end

end
