class ProfileMasterController < ApplicationController

  before_filter :authenticate_user!

  def main_edit
    respond_to do |format|
      format.html #main_edit.html.erb
    end
  end

  def main_save
  end

  def organization_edit
    respond_to do |format|
      format.html #organization_edit.html.erb
    end
  end

  def organization_save
  end

  def contacts_edit
    respond_to do |format|
      format.html #organization_edit.html.erb
    end
  end

  def contacts_save
  end

  def avatar_edit
    respond_to do |format|
      format.html #organization_edit.html.erb
    end
  end

  def avatar_save
  end

  def finish
  end

end
