# -*- coding: utf-8 -*-

#
# Webula SN
#
# Контроллер отображения профиля пользователя.
#
# Copyright (c) 2011, Alexey Plutalov
# License: GPL
#

# Контроллер отображения профиля пользователя.
class ProfilesController < ApplicationController

  # Отображает профиль текущего пользователя
  def index
  	respond_to do |format|
  	  format.html #index.html.erb
  	end
  end

  # Отображает профиль указанного профиля.
  #
  # Для поиска пользователя используется params[:username].
  def show
  	@user = User.first(conditions: { username: params[:username] })
  	@user_profile = @user.user_profile

  	respond_to do |format|
  	  format.html #show.html.erb
  	end
  end

end
