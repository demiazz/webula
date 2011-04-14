class Admin
  include Mongoid::Document
  
  devise :database_authenticatable,
  		 # ==> Modules
  		 :recoverable,
  		 :trackable,
  		 :validatable,
  		 :lockable,
  		 :timeoutable,
  		 # ==> Configuration for any authentication mechanism
  		 :authentication_keys => [ :email ],
  		 :case_insensitive_keys => [ :email ],
  		 # ==> Configuration for :database_authenticatable
  		 :stretches => 10,
  		 # ==> Configuration for :validatable
  		 :password_length => 8..32,
  		 # ==> Configuration for :timeoutable
  		 :timeout_in => 5.minutes,
  		 # ==> Configuration for :lockable
  		 :lock_strategy => :failed_attempts,
  		 :unlock_keys => [ :email ],
  		 :unlock_strategy => :both,
  		 :maximum_attempts => 5,
	  	 :unlock_in => 7.days,
		 # ==> Configuration for :recoverable
  		 :reset_password_keys => [ :email ]

end