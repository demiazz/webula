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
    respond_to do |format|
      format.html #main_edit.html.erb
    end
  end

  # Обновление основной пользовательской информации
  #
  # Проверяет данные, и сохраняет в профиль, либо возвращает форму заполнения с указанием ошибок.
  #
  # TODO:
  #   * Прямая передача массива в профиль
  #   * Рендеринг с заполненными полями и указанием ошибок
  def main_save
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

  # Редактирование информации о работе пользователя
  #
  # Отображает форму для заполнения информациио работе пользователя.
  def organization_edit
    respond_to do |format|
      format.html #organization_edit.html.erb
    end
  end

  # Обновление информации о работе пользователя
  #
  # Проверяет данные, и сохраняет в профиль, либо возвращает форму заполнения с указанием ошибок.
  #
  # TODO:
  #   * Прямая передача массива в профиль
  #   * Рендеринг с заполненными полями и указанием ошибок
  def organization_save
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

  # Редактирование контактных данных пользователя
  #
  # Отображает форму для заполнения контактных данных пользователя.
  def contacts_edit
    respond_to do |format|
      format.html #contacts_edit.html.erb
    end
  end

  # Обновление контактных данных пользователя
  #
  # Проверяет данные, и сохраняет в профиль, либо возвращает форму заполнения с указанием ошибок.
  #
  # TODO:
  #   * Прямая передача массива в профиль
  #   * Рендеринг с заполненными полями и указанием ошибок
  def contacts_save
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

  # Отображение итогового профиля пользователя
  def finish
    respond_to do |format|
      format.html #avatar_edit.html.erb
    end
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
      if not current_user.user_profile.new_profile
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
