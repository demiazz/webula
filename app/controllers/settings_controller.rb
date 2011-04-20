# -*- coding: utf-8 -*-

#
# Webula SN
#
# Контроллер настроек пользователя.
#
# Copyright (c) 2011, Alexey Plutalov
# License: GPL
#

# Контроллер настроек пользователя.
#
# Отвечает за редактирование профиля пользователя и смену аватара.
# В дальнейшем возможна агрегация других настроек и конфигураций.
# Функционал для редактирования пользовательского аккаунта предоставляется
# контроллером Users::Registrations.
class SettingsController < ApplicationController

  # Загрузка аватара пользователя
  #
  # Отображает форму для загрузки аватара пользователя.
  def avatar_edit
    respond_to do |format|
      format.html #avatar_edit.html.erb
    end
  end

  # Загрузка аватара пользователя
  #
  # Загружает аватар пользователя, сохраняет его, и сохраняет путь к аватару в профиле.
  #
  # TODO:
  #   * Имя файла на сервере должно быть {username}.{ext}
  def avatar_update
    uploaded_io = params[:avatar]
    File.open(Rails.root.join('public/images', 'avatars', uploaded_io.original_filename), 'wb') do |file|
      file.write(uploaded_io.read)
    end

    @user_profile.avatar = "avatars/" + params[:avatar].original_filename
    @user_profile.new_profile = false
  
    respond_to do |format|
      if @user_profile.save
        format.html { render :action => "avatar_edit" }
      else
        format.html { render :action => "avatar_edit" }
      end
    end
  end

  # Редактирование профиля пользователя.
  #
  # Отображает форму для профиля пользователя.
  def profile_edit
    respond_to do |format|
      format.html #avatar_edit.html.erb
    end
  end

  # Обновление профиля пользователя.
  #
  # Проверяет данные, и сохраняет в профиль, либо возвращает форму заполнения с указанием ошибок.
  #
  # TODO:
  #   * Прямая передача массива в профиль
  #   * Рендеринг с заполненными полями и указанием ошибок
  def profile_update
    @user_profile.first_name = params[:user_profile][:first_name]
    @user_profile.last_name = params[:user_profile][:last_name]
    @user_profile.gender = params[:user_profile][:gender]
    @user_profile.birthday = Date.new(params[:user_profile]["birthday(1i)"].to_i, params[:user_profile]["birthday(2i)"].to_i, params[:user_profile]["birthday(3i)"].to_i)
    @user_profile.country = params[:user_profile][:country]
    @user_profile.state = params[:user_profile][:state]
    @user_profile.city = params[:user_profile][:city]

    @user_profile.org_name = params[:user_profile][:org_name]
    @user_profile.org_country = params[:user_profile][:org_country]
    @user_profile.org_state = params[:user_profile][:org_state]
    @user_profile.org_city = params[:user_profile][:org_city]
    @user_profile.org_unit = params[:user_profile][:org_unit]
    @user_profile.org_position = params[:user_profile][:org_position]

    @user_profile.home_phone = params[:user_profile][:home_phone]
    @user_profile.work_phone = params[:user_profile][:work_phone]
    @user_profile.mobile_phone = params[:user_profile][:mobile_phone]
    @user_profile.mail = params[:user_profile][:mail]
    @user_profile.icq = params[:user_profile][:icq]
    @user_profile.xmpp = params[:user_profile][:xmpp]
    @user_profile.twitter = params[:user_profile][:twitter]

    respond_to do |format|
      if @user_profile.save
        format.html { render :action => "profile_edit" }
      else
        format.html { render :action => "profile_edit" }
      end
    end
  end

end
