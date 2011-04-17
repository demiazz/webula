class UserProfile
  include Mongoid::Document

  # ==> Model Fields

  # Main Info
  field :first_name, :type => String
  field :last_name, :type => String
  field :birthday, :type => Date
  field :country, :type => String
  field :state, :type => String
  field :city, :type => String
  # Organization Info
  field :org_name, :type => String
  field :org_country, :type => String
  field :org_state, :type => String
  field :org_city, :type => String
  field :org_unit, :type => String
  field :org_position, :type => String
  # Contacts
  field :home_phone, :type => String
  field :work_phone, :type => String
  field :mobile_phone, :type => String
  field :mail, :type => String
  field :icq, :type => String
  field :xmpp, :type => String
  field :twitter, :type => String
  # Avatar
  field :avatar, :type => String
  
end
