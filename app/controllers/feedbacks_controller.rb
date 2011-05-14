class FeedbacksController < ApplicationController

  def index
    if params[:consideres] == "both"
      @feedbacks_count,
      @feedbacks = get_feedbacks(Feedback.all.desc(:created_at))
    end
    if params[:consideres] == "yes"
      @feedbacks_count,
      @feedbacks = get_feedbacks(Feedback.where(:status => true).desc(:created_at))
    end
    if params[:consideres] == "no"
      @feedbacks_count,
      @feedbacks = get_feedbacks(Feedback.where(:status => false).desc(:created_at))
    end
  end

  def proposals
    if params[:consideres] == "both"
      @feedbacks_count,
      @feedbacks = get_feedbacks(Feedback.where(:feedback_type => "proposal").desc(:created_at))
    end
    if params[:consideres] == "yes"
      @feedbacks_count,
      @feedbacks = get_feedbacks(Feedback.where(:feedback_type => "proposal", :status => true).desc(:created_at))
    end
    if params[:consideres] == "no"
      @feedbacks_count,
      @feedbacks = get_feedbacks(Feedback.where(:feedback_type => "proposal", :status => false).desc(:created_at))
    end
  end

  def errors
    if params[:consideres] == "both"
      @feedbacks_count,
      @feedbacks = get_feedbacks(Feedback.where(:feedback_type => "error").desc(:created_at))
    end
    if params[:consideres] == "yes"
      @feedbacks_count,
      @feedbacks = get_feedbacks(Feedback.where(:feedback_type => "error", :status => true).desc(:created_at))
    end
    if params[:consideres] == "no"
      @feedbacks_count,
      @feedbacks = get_feedbacks(Feedback.where(:feedback_type => "error", :status => false).desc(:created_at))
    end
  end

  def create_feedback
    feedback = Feedback.new
    feedback.author = @user
    feedback.feedback_type = params[:feedback_type]
    feedback.subject = params[:feedback_subject]
    feedback.text = params[:feedback_text]
    feedback.status = false
    feedback.save
    redirect_to :back
  end

  def conside_feedback
    feedback = Feedback.where(:_id => params[:id]).first
    unless feedback.nil?
      feedback.status = true
      feedback.save
    end
    redirect_to :back
  end

  private

    def get_feedbacks(query)
      # Получаем paginate-коллекцию
      collection = query.paginate(:page => params[:page], :per_page => 20)
      # Определяем размер коллекции
      count = collection.size
      unless count == 0
        # Собираем id авторов постов
        author_ids = collection.map { |feedback| feedback.author_id }
        author_ids.uniq!
        # Собираем хэш авторов
        authors = Hash.new
        User.ids(author_ids).only(:id, :username, "user_profile.first_name",
                                  "user_profile.last_name", "user_profile.avatar").
                             each do |author|
          authors[author.id] = author
        end
        # Прикрепляем авторов к постам
        collection.each do |feedback|
          feedback.author = authors[feedback.author_id]
        end
      end
      return count, collection
    end

end
