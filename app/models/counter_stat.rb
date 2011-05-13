class CounterStat
  include Mongoid::Document

  # Число запросов
  field :count, :type => Integer, :default => 0

  # Контроллер и действие
  field :controller, :type => String, :default => ""
  field :action, :type => String, :default => ""

  # Дата (в своем формате)
  field :year, :type => Integer, :default => 0
  field :month, :type => Integer, :default => 0
  field :day, :type => Integer, :default => 0
  field :hour, :type => Integer, :default => 0
  
  # Ссылка на пользователя
  belongs_to :user, :class_name => "User"
end
