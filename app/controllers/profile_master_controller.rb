class ProfileMasterController < ActionController::Base

  protect_from_forgery

  before_filter :authenticate_user!
  before_filter :profile

  def main_edit
    respond_to do |format|
      format.html #main_edit.html.erb
    end
  end

  def main_save
    @user_profile = current_user.user_profile

    @user_profile.first_name = params[:first_name]
    @user_profile.last_name = params[:last_name]
    @user_profile.gender = params[:gender]
    @user_profile.birthday = Date.new(params[:birthday][:year].to_i, params[:birthday][:month].to_i, params[:birthday][:day].to_i)
    @user_profile.country = params[:country]
    @user_profile.state = params[:state]
    @user_profile.city = params[:city]

    respond_to do |format|
      if @user_profile.save
        format.html { redirect_to :controller => "profile_master", :action => "organization_edit" }
      else
        format.html { render :action => "main_edit" }
      end
    end
  end

  def organization_edit
    respond_to do |format|
      format.html #organization_edit.html.erb
    end
  end

  def organization_save
    @user_profile = current_user.user_profile

    @user_profile.org_name = params[:org_name]
    @user_profile.org_country = params[:org_country]
    @user_profile.org_state = params[:org_state]
    @user_profile.org_city = params[:org_city]
    @user_profile.org_unit = params[:org_unit]
    @user_profile.org_position = params[:org_position]

    respond_to do |format|
      if @user_profile.save
        format.html { redirect_to :controller => "profile_master", :action => "contacts_edit" }
      else
        format.html { render :action => "organization_edit" }
      end
    end
  end

  def contacts_edit
    respond_to do |format|
      format.html #contacts_edit.html.erb
    end
  end

  def contacts_save
    @user_profile = current_user.user_profile

    @user_profile.home_phone = params[:home_phone]
    @user_profile.work_phone = params[:work_phone]
    @user_profile.mobile_phone = params[:mobile_phone]
    @user_profile.mail = params[:mail]
    @user_profile.icq = params[:icq]
    @user_profile.xmpp = params[:xmpp]
    @user_profile.twitter = params[:twitter]

    respond_to do |format|
      if @user_profile.save
        format.html { redirect_to :controller => "profile_master", :action => "avatar_edit" }
      else
        format.html { render :action => "contacts_edit" }
      end
    end
  end

  def avatar_edit
    respond_to do |format|
      format.html #avatar_edit.html.erb
    end
  end

  def avatar_save
    @user_profile = current_user.user_profile

    uploaded_io = params[:avatar]
    File.open(Rails.root.join('public/images', 'avatars', uploaded_io.original_filename), 'wb') do |file|
      file.write(uploaded_io.read)
    end

    @user_profile.avatar = "avatars/" + params[:avatar].original_filename
    @user_profile.new_profile = false
  
    respond_to do |format|
      if @user_profile.save
        format.html { redirect_to :controller => "profile_master", :action => "finish" }
      else
        format.html { render :action => "avatar_edit" }
      end
    end
  end

  def finish
    @user_profile = current_user.user_profile

    respond_to do |format|
      format.html #avatar_edit.html.erb
    end
  end

  private

    def profile
      if not current_user.user_profile.new_profile
        redirect_to root_path
      end
    end

end
