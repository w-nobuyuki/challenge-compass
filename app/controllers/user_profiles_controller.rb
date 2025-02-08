# app/controllers/user_profiles_controller.rb
class UserProfilesController < ApplicationController
  before_action :authenticate_user!
  # プロフィールが既に入力済みなら、編集画面にリダイレクト（newアクションはプロフィール未登録の場合のみ）
  before_action :redirect_if_profile_completed, only: [ :new, :create ]

  def new
    @user_profile = current_user.build_user_profile
  end

  def create
    @user_profile = current_user.build_user_profile(user_profile_params)
    if @user_profile.save
      redirect_to root_path, notice: "プロフィールを登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_profile_params
    params.require(:user_profile).permit(:goal, :description, :background, :current_job, :gap_between_goal, :period)
  end

  def redirect_if_profile_completed
    redirect_to root_path if current_user.profile_completed?
  end
end
