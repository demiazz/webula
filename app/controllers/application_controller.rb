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
  # Подсчет обращений
  before_filter :counter

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
        if request.path_parameters()[:username].nil? or 
             request.path_parameters()[:username] == current_user.username
          @user = current_user
          @personal = true
        else
          @user = User.first(conditions: { username: params[:username] })
          @personal = false
        end
        @user_profile = @user.user_profile
      end
    end

    def counter
      today = DateTime.now.utc
      # Сборка статистики по контроллерам
      #
      # Учитывается запрос только к контроллеру.
      $controller_stat.multi do
        $controller_stat.incr "#{controller_name}__#{today.year}__#{today.month}__#{today.day}__#{today.hour}"
        $controller_stat.incr "#{controller_name}__#{today.year}__#{today.month}__#{today.day}"
        $controller_stat.incr "#{controller_name}__#{today.year}__#{today.month}"
        $controller_stat.incr "#{controller_name}__#{today.year}"
      end
      # Сборка статистики по actions
      #
      # Учитывается запрос только к action.
      $action_stat.multi do
        $action_stat.incr "#{controller_name}__#{action_name}__#{today.year}__#{today.month}__#{today.day}__#{today.hour}"
        $action_stat.incr "#{controller_name}__#{action_name}__#{today.year}__#{today.month}__#{today.day}"
        $action_stat.incr "#{controller_name}__#{action_name}__#{today.year}__#{today.month}"
        $action_stat.incr "#{controller_name}__#{action_name}__#{today.year}"
      end
      # Сборка статистики по users
      #
      # Учитываются запросы пользователей к конкретным контроллерам и action.
      if user_signed_in?
        $users_stat.multi do
          $users_stat.incr "#{current_user.id}__#{controller_name}__#{action_name}__#{today.year}__#{today.month}__#{today.day}__#{today.hour}"
          $users_stat.incr "#{current_user.id}__#{controller_name}__#{action_name}__#{today.year}__#{today.month}__#{today.day}"
          $users_stat.incr "#{current_user.id}__#{controller_name}__#{action_name}__#{today.year}__#{today.month}"
          $users_stat.incr "#{current_user.id}__#{controller_name}__#{action_name}__#{today.year}"
        end
      end
    end

end
