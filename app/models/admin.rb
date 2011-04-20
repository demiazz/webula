# -*- coding: utf-8 -*-

#
# Webula SN
#
# Модель администраторского аккаунта.
#
# Copyright (c) 2011, Alexey Plutalov
# License: GPL
#

# Модель администраторского аккаунта.
class Admin
  include Mongoid::Document

  # ==> Поля модели
  field :username, type: String # Имя пользователя
  field :email, type: String    # Электронная почта пользователя
  field :password, type: String # Пароль пользователя

  # ==> Доступ
  attr_accessible :username
  attr_accessible :email
  attr_accessible :password
  
  # Настройки расширения Devise
  devise :database_authenticatable,
         # Модули
         :recoverable,  # Восстановление
         :trackable,    # Слежение
         :validatable,  # Валидация
         :lockable,     # Блокировка
         :timeoutable,  # Временная блокировка
         # Конфигурация механизма аутентификации
         # аутентификация производится по :username
         :authentication_keys => [ :username ],
         # :username не чувствителен к регистру
         :case_insensitive_keys => [ :username ],
         # стойкость шифрования
         :stretches => 10,
         # Конфигурация валидации
         # длина пароля не меньше 8 символов и не более 32
         :password_length => 8..32,
         # Конфигурация выхода по времени
         # выходить через 5 минут
         :timeout_in => 5.minutes,
         # Конфигурация блокировки
         # блокируется при неудачном вводе пароля
         :lock_strategy => :failed_attempts,
         # для разблокировки используется :username
         :unlock_keys => [ :username ],
         # стратегии разблокировки
         :unlock_strategy => :both,
         # максимальное количество попыток ввода пароля
         :maximum_attempts => 5,
         # разблокировать через неделю
         :unlock_in => 7.days,
         # Конфигурация восстановления
         # сброс пароля по :username
         :reset_password_keys => [ :username ]

end