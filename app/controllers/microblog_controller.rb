class MicroblogController < ApplicationController

  # Глобальная лента
  def global_feed
    # Получение всех постов с сортировкой по дате создания
    @posts = MicroblogPost.all.desc(:created_at).to_a
    # Генерация списка id авторов постов
    author_ids = Array.new
    @posts.each do |post|
      author_ids << post.author_id
    end
    # Получение авторов постов по id
    authors = Hash.new
    User.where(:_id.in => author_ids.uniq).
         only(:id, :username, "user_profile.first_name", "user_profile.last_name")
         .each do |author|
      authors[author.id] = author
    end
    # Присваивание авторов постам по author_id
    @posts.each do |post|
      post.author = authors[post.author_id]
    end
  end

  def local_feed
  end

  # Персональная лента
  def personal_feed
    # Получение всех постов с сортировкой по дате создания
    @posts = @user.microblog_posts.desc(:created_at)
  end

  def followings_feed
  end

  def followers_feed
  end

  def followings
  end

  def followers
  end

  def add_following
  end

  def remove_following
  end

  def create_post
  end

  def delete_post
  end

end
