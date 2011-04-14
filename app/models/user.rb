class User
  include Mongoid::Document

  devise :database_authenticatable,
         # ==> Modules
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :confirmable,
         :lockable,
         :timeoutable,
         # ==> Configuration for any authentication mechanism
         :authentication_keys => [ :email ],
         :case_insensitive_keys => [ :email ],
         # ==> Configuration for :database_authenticatable
         :stretches => 10,
         # ==> Configuration for :confirmable
         :confirm_within => 7.days,
         :confirmation_keys => [ :email ],
         # ==> Configuration for :rememberable
         :remember_for => 7.days,
         :remember_across_browsers => true,
         :extend_remember_period => false,
         # ==> Configuration for :validatable
         :password_length => 8..32,
         # ==> Configuration for :timeoutable
         :timeout_in => 1.hour,
         # ==> Configuration for :lockable
         :lock_strategy => :failed_attempts,
         :unlock_keys => [ :email ],
         :unlock_strategy => :both,
         :maximum_attempts => 10,
         :unlock_in => 1.hour,
         # ==> Configuration for :recoverable
         :reset_password_keys => [ :email ]
end