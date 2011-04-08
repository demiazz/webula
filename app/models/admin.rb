class Admin
  include Mongoid::Document

  # Devise Modules
  devise :database_authenticatable, 
         :recoverable, 
         :trackable, 
         :validatable,
         :confirmable,
         :lockable,
         :timeoutable

end
