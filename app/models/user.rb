class User
  include Mongoid::Document

  # ==> Model Fields
  field :username, type: String
  field :email, type: String
  field :password, type: String

  # ==> Relations
  embeds_one :user_profile

  # ==> Accessible
  attr_accessible :username
  attr_accessible :email
  attr_accessible :password

  # ==> Callbacks
  before_create :create_profile

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
         :authentication_keys => [ :username ],
         :case_insensitive_keys => [ :username ],
         # ==> Configuration for :database_authenticatable
         :stretches => 10,
         # ==> Configuration for :confirmable
         :confirm_within => 7.days,
         :confirmation_keys => [ :username ],
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
         :unlock_keys => [ :username ],
         :unlock_strategy => :both,
         :maximum_attempts => 10,
         :unlock_in => 1.hour,
         # ==> Configuration for :recoverable
         :reset_password_keys => [ :username ]

  protected

    def create_profile
      self.user_profile = UserProfile.new
      self.user_profile.new_profile = true
    end

end