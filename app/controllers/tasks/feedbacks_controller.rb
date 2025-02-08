class Tasks::FeedbacksController < ApplicationController
  before_action :set_task
  def new
    @feedback = @task.build_feedback
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
      @feedback.update!(ai_comment: FeedbackGenerateAi.call(prompt: current_user.feedback_prompt))

      redirect_to @task, notice: "フィードバックを保存しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_task
    @task = Task.find(params[:task_id])
  end

  def feedback_params
    params.require(:feedback).permit(:comment)
  end
end
