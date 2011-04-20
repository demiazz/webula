# -*- coding: utf-8 -*-

#
# Webula SN
#
# Контроллер мастера заполнения профиля пользователя.
#
# Copyright (c) 2011, Alexey Plutalov
# License: GPL
#

# Контроллер мастера заполнения профиля пользователя.
class ProfileMasterController < ActionController::Base

  protect_from_forgery

  # Требует аутентификации пользователя
  before_filter :authenticate_user!
  # Переключатель мастера профиля
  before_filter :profile
  # Автозагрузка профиля пользователя
  before_filter :profile_autoload

  # Редактирование основной пользовательской информации
  #
  # Отображает форму для заполнения основной информации о пользователе.
  def main_edit
  end

  # Обновление основной пользовательской информации
  #
  # Проверяет данные, и сохраняет в профиль, либо возвращает форму заполнения с указанием ошибок.
  #
  # TODO:
  #   * Рендеринг с заполненными полями и указанием ошибок
  def main_save
    params[:user_profile][:birthday] = Date.new(params[:user_profile]["birthday(1i)"].to_i, 
                                                params[:user_profile]["birthday(2i)"].to_i, 
                                                params[:user_profile]["birthday(3i)"].to_i)
    params[:user_profile]["birthday(1i)"] = nil
    params[:user_profile]["birthday(2i)"] = nil
    params[:user_profile]["birthday(3i)"] = nil

    if params[:user_profile][:gender] == "true"
      @user_profile[:avatar] = "avatars/default-male-avatar.jpg"
    else
      @user_profile[:avatar] = "avatars/default-female-avatar.jpg"
    end

    respond_to do |format|
      if @user_profile.update_attributes(params[:user_profile])
        format.html { redirect_to profile_master__organization_edit_path }
      else
        format.html { render :action => "main_edit" }
      end
    end
  end

  # Редактирование информации о работе пользователя
  #
  # Отображает форму для заполнения информациио работе пользователя.
  def organization_edit
  end

  # Обновление информации о работе пользователя
  #
  # Проверяет данные, и сохраняет в профиль, либо возвращает форму заполнения с указанием ошибок.
  #
  # TODO:
  #   * Рендеринг с заполненными полями и указанием ошибок
  def organization_save
    respond_to do |format|
      if @user_profile.update_attributes(params[:user_profile])
        format.html { redirect_to profile_master__contacts_edit_path }
      else
        format.html { render :action => "organization_edit" }
      end
    end
  end

  # Редактирование контактных данных пользователя
  #
  # Отображает форму для заполнения контактных данных пользователя.
  def contacts_edit
  end

  # Обновление контактных данных пользователя
  #
  # Проверяет данные, и сохраняет в профиль, либо возвращает форму заполнения с указанием ошибок.
  #
  # TODO:
  #   * Рендеринг с заполненными полями и указанием ошибок
  def contacts_save
    respond_to do |format|
      if @user_profile.update_attributes(params[:user_profile])
        format.html { redirect_to profile_master__avatar_edit_path }
      else
        format.html { render :action => "contacts_edit" }
      end
    end
  end

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
  def avatar_save
    unless params[:avatar].nil?
      uploaded_io = params[:avatar]
      File.open(Rails.root.join('public/images/avatars', uploaded_io.original_filename), 'wb') do |file|
        file.write(uploaded_io.read)
      end
      @user_profile.avatar = "avatars/" + params[:avatar].original_filename
    end

    @user_profile.new_profile = false
  
    respond_to do |format|
      if @user_profile.save
        format.html { redirect_to profile_master__finish_path }
      else
        format.html { render :action => "avatar_edit" }
      end
    end
  end

  # Отображение итогового профиля пользователя
  def finish
  end

  private

    # Загрузка пользовательской информации
    #
    # При каждом запросе производит загрузку аккаунта и профиля
    # пользователя.
    # * Если пользователь авторизован, происходит загрузка.
    # * Если страница для текущего пользователя, то используется
    #   current_user.
    # * Если страница не текущего пользователя, то загружается
    #   информация пользователя с username из params[:username].
    def profile
      unless current_user.user_profile.new_profile
        redirect_to root_path
      end
    end

    # Автозагрузка профиля пользователя
    #
    # Производит автозагрузку профиля текущего пользователя, так как
    # во всех actions он используется.
    def profile_autoload
      @user_profile = current_user.user_profile
    end

end
