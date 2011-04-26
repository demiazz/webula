class MicroblogPost
  include Mongoid::Document

  field :text, :type => String

  belongs_to :author, :class_name => "User", :inverse_of => :microblog_posts

end
