class Tasks::FeedbacksController < ApplicationController
  before_action :set_task
  def new
    if @task.feedback.present? && @task.today?
      redirect_to task_feedback_path(@task, @task.feedback)
      return
    end

    @feedback = @task.build_feedback
  end

  def show
    @feedback = @task.feedback
  end

  def create
    @feedback = @task.build_feedback(feedback_params)
    if @feedback.save
      if params[:challenge_feedbacks].present?
        params[:challenge_feedbacks].each do |challenge_id, feedback_value|
          challenge = @task.challenges.find(challenge_id)
          challenge.update(feedback: feedback_value)
        end
      end
      @feedback.update!(ai_comment: FeedbackGenerateAi.call(prompt: current_user.feedback_prompt, mentor: @feedback.mentor))
      respond_to do |format|
        format.turbo_stream
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:task_id])
  end

  def feedback_params
    params.require(:feedback).permit(:comment, :mentor)
  end
end
