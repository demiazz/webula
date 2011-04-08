class User
  include Mongoid::Document
  
  # Devise Modules
  devise :database_authenticatable, 
         :registerable,
         :recoverable, 
         :rememberable, 
         :trackable, 
         :validatable,
         :confirmable, 
         :lockable, 
         :timeoutable

end
