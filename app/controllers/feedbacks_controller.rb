class FeedbacksController < ApplicationController

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
end
