class Answer
  include Mongoid::Document
  include Mongoid::Timestamps

  field :text, :type => String, :default => ""
  field :vote, :type => Integer, :default => 0
  field :voter_ids, :type => Array, :default => []

  belongs_to :author, :class_name => "User"
  embedded_in :question, :class_name => "Question", :inverse_of => :answers
end
