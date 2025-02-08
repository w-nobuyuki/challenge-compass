class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :ensure_profile_complete, unless: :devise_controller?

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  def ensure_profile_complete
    # ユーザーがログインしており、かつプロフィールが未入力の場合
    if user_signed_in? && !current_user.profile_completed? && !on_user_profile_page?
      redirect_to new_user_profile_path, alert: "\u4ED6\u306E\u30DA\u30FC\u30B8\u306B\u30A2\u30AF\u30BB\u30B9\u3059\u308B\u524D\u306B\u3001\u30D7\u30ED\u30D5\u30A3\u30FC\u30EB\u3092\u5165\u529B\u3057\u3066\u304F\u3060\u3055\u3044\u3002"
    end
  end

  def on_user_profile_page?
    controller_name == "user_profiles"
  end
end
