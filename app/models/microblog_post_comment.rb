class MicroblogPostComment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :text, :type => String
  field :parent, :type => String

  belongs_to :author, :class_name => "User"
  embedded_in :post, :class_name => "MicroblogPost", :inverse_of => :comments
end
