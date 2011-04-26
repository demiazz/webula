class MicroblogPost
  include Mongoid::Document
  field :text, :type => String
end
