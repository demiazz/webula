module Extensions::User::Friendship

  # Связи
  embeds_one :friendship_stat # Статистика пользовательских отношений
  has_and_belongs_to_many :friends, :class_name => "User"

end