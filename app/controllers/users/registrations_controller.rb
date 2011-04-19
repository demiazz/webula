class Users::RegistrationsController < Devise::RegistrationsController
	
  def after_update_path_for(resource)
	url_for :action => "edit"
  end

end