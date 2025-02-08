# app/controllers/tasks_controller.rb
class TasksController < ApplicationController
  before_action :authenticate_user!

  def index
    @tasks = current_user.tasks.order(date: :desc)
  end

  def new
    if current_user.tasks.today.exists?
      redirect_to new_task_feedback_path(current_user.tasks.today.last)
      return
    end
    @task = current_user.tasks.build
  end

  def create
    @task = current_user.tasks.build(task_params)
    @task.date ||= Date.today
    if @task.save
      redirect_to tasks_path, notice: "本日のチャレンジを確定しました！"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @task = current_user.tasks.find(params[:id])
  end

  def generate_challenges
    @task = current_user.tasks.build(task_params)
    challenges = ChallengeGenerateAi.call(prompt: current_user.prompt)
    challenges.each do |challenge_num, body|
      @task.challenges.build(level: body["level"], title: body["title"], content: body["content"])
    end
    render partial: "challenges", locals: { task: @task }
  end

  private

  def task_params
    params.require(:task).permit(:content, challenges_attributes: %i[level title content])
  end
end
