# -*- coding: utf-8 -*-

#
# Webula SN
#
# Базовый класс контроллера.
#
# Copyright (c) 2011, Alexey Plutalov
# License: GPL
#

# Базовый класс контроллера
class ApplicationController < ActionController::Base

  protect_from_forgery

  # Требует аутентификации пользователя
  before_filter :authenticate_user!
  # Переключатель мастера профиля
  before_filter :profile
  # Загрузка пользовательской информации
  before_filter :personalize

  private
    
    # Переключатель мастера профиля
    # 
    # Включает/выключает мастер профиля для пользователя.
    # * Если пользователь имеет профиль, то мастер недоступен.
    # * Если пользователь не имеет профиля, то мастер доступен.
    def profile
      if user_signed_in? and current_user.user_profile.new_profile
        redirect_to :controller => "profile_master", :action => "main_edit"
      end
    end

    # Загрузка пользовательской информации
    #
    # При каждом запросе производит загрузку аккаунта и профиля
    # пользователя.
    # * Если пользователь авторизован, происходит загрузка.
    # * Если страница для текущего пользователя, то используется
    #   current_user.
    # * Если страница не текущего пользователя, то загружается
    #   информация пользователя с username из params[:username].
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
