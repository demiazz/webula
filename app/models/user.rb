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

  # Поля модели
  field :username, type: String # Имя пользователя
  field :email, type: String    # Электронная почта пользователя
  field :password, type: String # Пароль пользователя

  # Отношения
  embeds_one :user_profile      # Имеет встроенный документ профиля пользователя

  # Friendship Framework
  has_one :friendship, :class_name => "Friendship", :inverse_of => :owner
  # Посты в микроблоге пользователя
  has_many :microblog_posts, :class_name => "MicroblogPost", :inverse_of => :author
  # Имеет один микроблог
  has_one :microblog, :class_name => "Microblog", :inverse_of => :owner
  # Имеет исходящую почту
  has_many :outbox_messages, :class_name => "Message", :inverse_of => :sender
  # Имеет входящую почту
  has_many :inbox_messages, :class_name => "Message", :inverse_of => :recipient
  # Имеет один почтовый аккаунт
  has_one :mail, :class_name => "Microblog", :inverse_of => :owner
  # Имеет много вопросов
  has_many :questions, :class_name => "Question", :inverse_of => :author

  # Scopes
  scope :ids, ->(ids) { where(:_id.in => ids) }
  scope :username, ->(username) { where(:username => username) }

  # Доступ
  attr_accessible :username
  attr_accessible :email
  attr_accessible :password
  
  # Буферный флаг. Только для локального использования (!!!)
  attr_accessor :buffer

  # Обратные вызовы
  before_create :create_profile
  before_create :create_friendship
  before_create :create_microblog
  before_create :create_mail

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

  def full_name
    "#{user_profile.first_name} #{user_profile.last_name}"
  end

  protected

    # Создание профиля
    #
    # Прежде чем сохранить аккаунт, создает профиль пользователя.
    def create_profile
      self.user_profile = UserProfile.new
    end

    def create_friendship
      friendship = Friendship.new
      friendship.owner = self
      friendship.save
    end

    def create_microblog
      microblog = Microblog.new
      microblog.owner = self
      microblog.save
    end

    def create_mail
      mail = Mail.new
      mail.owner = self
      mail.save
    end

end