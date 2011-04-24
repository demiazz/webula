class FriendshipStat
  include Mongoid::Document

  field :friends_count, :type => Integer, :default => 0
  field :requests_to_count, :type => Integer, :default => 0
  field :requests_from_count, :type => Integer, :default => 0

  embedded_in :user

end
