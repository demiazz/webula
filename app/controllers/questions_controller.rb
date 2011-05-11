#coding: utf-8

class QuestionsController < ApplicationController

  def index
    @new_question = Question.new
    @questions_count,
    @questions = get_questions(Question.all.
                                        only(:id, :text, 
                                             :answers_count, :tags, 
                                             :author_id, :created_at).
                                        desc(:created_at))
  end

  def personal_questions
    @new_question = Question.new
    @questions_count,
    @questions = get_questions(Question.where(:author_id => @user.id).
                                        only(:id, :text, 
                                             :answers_count, :tags, 
                                             :author_id, :created_at).
                                        desc(:created_at))
  end

  def friends_questions
    friendship = @user.friendship
    @questions_count,
    @questions = get_questions(Question.where(:author_id.in => friendship.friend_ids).
                                        only(:id, :text, 
                                             :answers_count, :tags, 
                                             :author_id, :created_at).
                                        desc(:created_at))
  end

  def show
    @question = Question.where(:_id => params[:id]).first
    unless @question.nil?
      @answers = @question.answers
      author_ids = []
      @answers.each do |answer|
        author_ids << answer.author_id
      end
      author_ids.uniq!
      authors = Hash.new
      User.ids(author_ids).
           #only(:id, :username, "user_profile.first_name",
           #     "user_profile.last_name", "user_profile.avatar").
           each do |user|
        authors[user.id] = user
      end
      @answers.each do |answer|
        answer.author = authors[answer.author_id]
      end
      @answers.sort! { |first, second| second.vote <=> first.vote }
    end
  end

  def create_question
    question = Question.new
    question.author = @user
    # Пробел прибавляем для обхода регулярки, которая не находит тег, стоящий
    # в самом начале строки.
    question.text = " #{params[:question][:text]}"
    # Парсинг текста на наличие хэш-тегов
    hashtags = params[:question][:text].scan(/#[a-zA-Zа-яА-Я0-9]*\b/)
    if hashtags.size > 0
      hashtags.map! { |hashtag| hashtag[1..hashtag.size].mb_chars.downcase.to_s }
      hashtags.uniq!
      question.tags |= hashtags
    end
    # Парсинг дополнительной строки тегов
    tags = params[:question][:tags].split(" ").map! { |tag| tag.mb_chars.strip.downcase.to_s }
    question.tags |= tags if (not tags.nil?) and (tags.size > 0)
    question.save
    redirect_to :back
  end

  def delete_question
    question = Question.where(:id => params[:id], :author_id => @user.id)
    unless question.nil?
      question.destroy
    end
    redirect_to :back
  end

  def add_answer
    question = Question.where(:_id => params[:question_id]).first
    unless question.nil?
      answer = Answer.new
      answer.author = @user
      answer.text = params[:text]
      question.answers << answer
      question.answers_count += 1
      question.save
    end
    redirect_to :back
  end

  def vote_up_answer
    question = Question.where(:_id => params[:question_id]).first
    unless question.nil?
      question.answers.each do |answer|
        if answer.id.to_s == params[:answer_id].to_s
          unless answer.voter_ids.include?(@user.id)
            answer.voter_ids << @user.id
            answer.vote += 1
            answer.save
            question.save
            break
          end
        end
      end
    end
    redirect_to :back
  end

  def vote_down_answer
    question = Question.where(:_id => params[:question_id]).first
    unless question.nil?
      question.answers.each do |answer|
        if answer.id.to_s == params[:answer_id].to_s
          unless answer.voter_ids.include?(@user.id)
            answer.voter_ids << @user.id
            answer.vote -= 1
            answer.save
            question.save
            break
          end
        end
      end
    end
    redirect_to :back
  end

  def questions_by_tag
    @tag = params[:tag]
    @questions_count,
    @questions = get_questions(Question.where(:tags => params[:tag]).desc(:created_at).
                                        only(:id, :author_id, :text,
                                             :created_at, :tags, :answers_count))
  end

  def search
    unless params.nil? or params[:query].size == 0
      @query = params[:query]
      query_tags = params[:query].split(" ").map! { |tag| tag.mb_chars.strip.downcase.to_s }
      if query_tags.size > 0
        @questions_count,
        @questions = get_questions(Question.where(:tags.in => query_tags).desc(:created_at).
                                            only(:id, :author_id, :text,
                                                 :created_at, :tags, :answers_count))
      else
        @questions_count,
        @questions = get_questions(Question.all.desc(:created_at).
                                                only(:id, :author_id, :text,
                                                     :created_at, :tags, 
                                                     :answers_count))
      end
    else
      @questions_count,
      @questions = get_questions(Question.all.desc(:created_at).
                                             only(:id, :author_id, :text,
                                                  :created_at, :tags, :answers_count))
      @query = ""
    end
  end

  private

    def get_questions(query)
      # Получаем paginate-коллекцию
      collection = query.paginate(:page => params[:page], :per_page => 20)
      # Определяем размер коллекции
      count = collection.size
      unless count == 0
        # Собираем id авторов постов
        author_ids = collection.map { |question| question.author_id }
        author_ids.uniq!
        # Собираем хэш авторов
        authors = Hash.new
        User.ids(author_ids).only(:id, :username, "user_profile.first_name",
                                  "user_profile.last_name", "user_profile.avatar").
                             each do |author|
          authors[author.id] = author
        end
        # Прикрепляем авторов к постам
        collection.each do |question|
          question.author = authors[question.author_id]
        end
      end
      return count, collection
    end

end
