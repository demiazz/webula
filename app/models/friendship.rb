class Friendship
  include Mongoid::Document

  field :friend_ids, :type => Array, :default => []
  field :request_to_ids, :type => Array, :default => []
  field :request_from_ids, :type => Array, :default => []
  field :friends_count, :type => Integer, :default => 0
  field :requests_to_count, :type => Integer, :default => 0
  field :request_from_count, :type => Integer, :default => 0

end
