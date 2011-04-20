# -*- coding: utf-8 -*-

#
# Webula SN
#
# Модель пользовательского аккаунта.
#
# Copyright (c) 2011, Alexey Plutalov
# License: GPL
#

# Модель пользовательского аккаунта.
class User
  include Mongoid::Document

  # ==> Поля модели
  field :username, type: String # Имя пользователя
  field :email, type: String    # Электронная почта пользователя
  field :password, type: String # Пароль пользователя

  # ==> Отношения
  embeds_one :user_profile      # Имеет встроенный документ профиля пользователя

  # ==> Доступ
  attr_accessible :username
  attr_accessible :email
  attr_accessible :password

  # ==> Обратные вызовы
  before_create :create_profile

  # Настройки расширения Devise
  devise :database_authenticatable,
         # Модули
         :registerable, # Регистрация
         :recoverable,  # Восстановление
         :rememberable, # Запоминание
         :trackable,    # Слежение
         :validatable,  # Валидация
         :confirmable,  # Подтверждение
         :lockable,     # Блокировка
         :timeoutable,  # Временная блокировка
         # Конфигурация механизма аутентификации
         # аутентификация производится по :username
         :authentication_keys => [ :username ],
         # :username не чувствителен к регистру
         :case_insensitive_keys => [ :username ],
         # стойкость шифрования
         :stretches => 10,
         # Конфигурация подтверждения
         # аккаунт должен быть подтвержден в течении 7 дней
         :confirm_within => 7.days,
         # ключ для подтверждения - :username
         :confirmation_keys => [ :username ],
         # Конфигурация запоминания
         # помнить пользователя 7 дней
         :remember_for => 7.days,
         # запоминание работает между браузерами?
         :remember_across_browsers => true,
         # расширять период запоминания?
         :extend_remember_period => false,
         # ==> Configuration for :validatable
         # Конфигурация валидации
         # длина пароля не меньше 8 символов и не более 32
         :password_length => 8..32,
         # Конфигурация выхода по времени
         # выходить через час
         :timeout_in => 1.hour,
         # Конфигурация блокировки
         # блокируется при неудачном вводе пароля
         :lock_strategy => :failed_attempts,
         # для разблокировки используется :username
         :unlock_keys => [ :username ],
         # стратегии разблокировки
         :unlock_strategy => :both,
         # максимальное количество попыток ввода пароля
         :maximum_attempts => 10,
         # разблокировать через час
         :unlock_in => 1.hour,
         # Конфигурация восстановления
         # сброс пароля по :username
         :reset_password_keys => [ :username ]

  protected

    # Создание профиля
    #
    # Прежде чем сохранить аккаунт, создает профиль пользователя.
    def create_profile
      self.user_profile = UserProfile.new
      self.user_profile.new_profile = true
    end

end