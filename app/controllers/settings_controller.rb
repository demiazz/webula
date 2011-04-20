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
  end

  # Загрузка аватара пользователя
  #
  # Загружает аватар пользователя, сохраняет его, и сохраняет путь к аватару в профиле.
  #
  # TODO:
  #   * Имя файла на сервере должно быть {username}.{ext}
  def avatar_update
    unless params[:avatar].nil?
      uploaded_io = params[:avatar]
      File.open(Rails.root.join('public/images/avatars', uploaded_io.original_filename), 'wb') do |file|
        file.write(uploaded_io.read)
      end
      @user_profile.avatar = "avatars/" + params[:avatar].original_filename
    end

    @user_profile.save

    render :action => "avatar_edit"
  end

  # Редактирование профиля пользователя.
  #
  # Отображает форму для профиля пользователя.
  def profile_edit
  end

  # Обновление профиля пользователя.
  #
  # Проверяет данные, и сохраняет в профиль, либо возвращает форму заполнения с указанием ошибок.
  #
  # TODO:
  #   * Рендеринг с заполненными полями и указанием ошибок
  def profile_update
    params[:user_profile][:birthday] = Date.new(params[:user_profile]["birthday(1i)"].to_i, 
                                                params[:user_profile]["birthday(2i)"].to_i, 
                                                params[:user_profile]["birthday(3i)"].to_i)
    params[:user_profile]["birthday(1i)"] = nil
    params[:user_profile]["birthday(2i)"] = nil
    params[:user_profile]["birthday(3i)"] = nil

    @user_profile.update_attributes(params[:user_profile])

    render :action => "profile_edit"
  end

end
