class MicroblogPost
  include Mongoid::Document
  include Mongoid::Timestamps

  field :text, :type => String

  belongs_to :author, :class_name => "User", :inverse_of => :microblog_posts

end
