class Question
  include Mongoid::Document
  include Mongoid::Timestamps

  field :text, :type => String, :default => ""
  field :tags, :type => Array, :default => []
  field :answers_count, :type => Integer, :default => 0

  belongs_to :author, :class_name => "User", :inverse_of => :questions
  embeds_many :answers, :class_name => "Answer", :inverse_of => :question

end
