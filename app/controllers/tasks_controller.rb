# app/controllers/tasks_controller.rb
class TasksController < ApplicationController
  before_action :authenticate_user!

  def index
    @tasks = current_user.tasks.order(date: :desc)
  end

  def new
    # 本日の日付を自動設定
    @task = current_user.tasks.new(date: Date.today)
  end

  def create
    @task = current_user.tasks.new(task_params)
    @task.date ||= Date.today

    if @task.save
      challenges = ChallengeGenerateAi.call(prompt: current_user.prompt)
      challenges.each do |challenge_num, body|
        @task.challenges.create!(level: body["level"], title: body["title"], content: body["content"])
      end
      redirect_to tasks_path, notice: "タスクが作成されました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @task = current_user.tasks.find(params[:id])
  end

  private

  def task_params
    params.require(:task).permit(:content, :date)
  end
end
