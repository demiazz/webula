class Feedback
  include Mongoid::Document
  include Mongoid::Timestamps

  field :feedback_type, :type => String, :default => ""
  field :subject, :type => String, :default => ""
  field :text, :type => String, :default => ""
  field :status, :type => Boolean, :default => false

  belongs_to :author, :class_name => "User"
end
