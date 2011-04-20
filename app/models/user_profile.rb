# -*- coding: utf-8 -*-

#
# Webula SN
#
# Модель профиля пользователя.
#
# Copyright (c) 2011, Alexey Plutalov
# License: GPL
#

# Модель профиля пользователя.
class UserProfile
  include Mongoid::Document

  # Поля модели
  # Основная информация о пользователе
  field :first_name, type: String, default: ""         # Имя
  field :last_name, type: String, default: ""          # Фамилия
  field :gender, type: Boolean, default: true       # Пол
  field :birthday, type: Date, default: Date.new(1920, 1, 1) # Дата рождения
  field :country, type: String, default: ""            # Страна
  field :state, type: String, default: ""              # Штат(край/область)
  field :city, type: String, default: ""               # Город
  # Информация о рабочем месте
  field :org_name, type: String, default: ""           # Организация
  field :org_country, type: String, default: ""        # Страна организации
  field :org_state, type: String, default: ""          # Штат организации
  field :org_city, type: String, default: ""           # Город организации
  field :org_unit, type: String, default: ""           # Отдел(подразделение)
  field :org_position, type: String, default: ""       # Должность
  # Контактная информация
  field :home_phone, type: String, default: ""         # Домашний телефон
  field :work_phone, type: String, default: ""         # Рабочий телефон
  field :mobile_phone, type: String, default: ""       # Мобильный телефон
  field :mail, type: String, default: ""               # Электронная почта
  field :icq, type: String, default: ""                # Номер ICQ 
  field :xmpp, type: String, default: ""               # Идентификатор XMPP
  field :skype, type: String, default: ""              # Идентификатор Skype
  field :twitter, type: String, default: ""            # Аккаунт в Twitter
  # Аватар
  field :avatar, type: String, default: "avatars/default-male-avatar.jpg" # Аватар
  # Метка нового профиля
  field :new_profile, type: Boolean, default: true  # Метка нового профиля

  # Отношения
  embedded_in :user                                    # Встроен в аккаунт

end
