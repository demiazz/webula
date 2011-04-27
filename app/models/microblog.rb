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

end
