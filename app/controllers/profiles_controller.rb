class ProfilesController < ApplicationController

  def index
  	@user = current_user
  	@user_profile = current_user.user_profile

  	respond_to do |format|
  	  format.html #index.html.erb
  	end
  end

  def show
  	@user = User.first(conditions: { username: params[:username] })
  	@user_profile = @user.user_profile

  	respond_to do |format|
  	  format.html #show.html.erb
  	end
  end

end
