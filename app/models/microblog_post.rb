class MicroblogPost
  include Mongoid::Document
  include Mongoid::Timestamps

  field :text, :type => String

  belongs_to :author, :class_name => "User", :inverse_of => :microblog_posts

  # Scopes
  scope :all_posts, all.desc(:created_at)
  scope :author_ids, ->(ids) { where(:author_id.in => ids).desc(:created_at) }
  scope :author_id, ->(id) { where(:author_id => id).desc(:created_at) }

end
