# -*- coding: utf-8 -*-

#
# Webula SN
#
# Замена для Devise::RegistrationsController для
# модели User.
#
# Copyright (c) 2011, Alexey Plutalov
# License: GPL
#

# Класс замена для Devise::RegistrationsController.
class Users::RegistrationsController < Devise::RegistrationsController

  # Изменяет перенаправление после обновления профиля пользователя.
  def after_update_path_for(resource)
    url_for :action => "edit"
  end

end