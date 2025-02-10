class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :ensure_profile_complete, unless: :devise_controller?

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  def ensure_profile_complete
    if user_signed_in? && !current_user.profile_completed? && !on_user_profile_page?
      redirect_to new_user_profile_path
    end
  end

  def on_user_profile_page?
    controller_name == "user_profiles"
  end
end
