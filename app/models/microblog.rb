class Microblog
  include Mongoid::Document

  # Пользователи, которых читает пользователь по id
  field :following_ids, :type => Array, :default => []
  # Читатели пользователя по id
  field :follower_ids, :type => Array, :default => []
  # Число пользователей, которых пользователь читает
  field :followings_count, :type => Integer, :default => 0
  # Число читателей пользователя
  field :followers_count, :type => Integer, :default => 0
  # Количество постов пользователя
  field :posts_count, :type => Integer, :default => 0

  # Имеет одного хозяина
  belongs_to :owner, :class_name => "User", :inverse_of => :microblog

  # Scopes
  scope :owner_id, ->(id) { where(:owner_id => id) }

  def followings
    User.ids(following_ids)
  end

  def followers
    User.ids(follower_ids)
  end

  def following?(id)
    following_ids.include?(id)
  end

  def follower?(id)
    following_ids.include?(id)
  end

  def add_following!(id)
    unless self.following?(id)
      self.following_ids << id
    end
    self.followings_count = self.following_ids.size
    self.save
  end

  def remove_following!(id)
    if self.following?(id)
      self.following_ids.delete(id)
    end
    self.followings_count = self.following_ids.size
    self.save
  end

  def add_follower!(id)
    unless self.follower?(id)
      self.follower_ids << id
    end
    self.followers_count = self.follower_ids.size
    self.save
  end

  def remove_follower!(id)
    if self.follower?(id)
      self.follower_ids.delete(id)
    end
    self.followers_count = self.follower_ids.size
    self.save
  end

end
