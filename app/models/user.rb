class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2]

  has_one :user_profile, dependent: :destroy
  has_many :tasks, dependent: :destroy

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data["email"]).first

    unless user
      user = User.create(
        email: data["email"],
        password: Devise.friendly_token[0, 20]
      )
    end
    user
  end

  def profile_completed?
    user_profile.present? && user_profile.goal.present?
  end

  def prompt
    <<~PROMPT
      ## 目指す姿
      * #{user_profile.goal}

      ## 目指す姿の説明
      * #{user_profile.description}

      ## 背景
      * #{user_profile.background}

      ## 現在の仕事
      * #{user_profile.current_job}

      ## 目指す姿とのギャップ
      * #{user_profile.gap_between_goal}

      ## 目指す期間
      * #{user_profile.period}

      ## 今日のタスク
      #{tasks.last.content}
    PROMPT
  end

  def feedback_prompt
    <<~PROMPT
      ## 目指す姿
      * #{user_profile.goal}

      ## 目指す姿の説明
      * #{user_profile.description}

      ## 背景
      * #{user_profile.background}

      ## 現在の仕事
      * #{user_profile.current_job}

      ## 目指す姿とのギャップ
      * #{user_profile.gap_between_goal}

      ## 目指す期間
      * #{user_profile.period}

      ## 昨日のタスク
      #{tasks.last.content}

      ## 昨日のチャレンジ
      #{tasks.last.challenges.map { |c| "* タイトル：#{c.title} \n * 内容：#{c.content} \n * 達成状況：#{c.feedback}" }.join("\n")}

      ## 昨日のチャレンジに対するユーザーのコメント
      #{tasks.last.feedback&.comment}
    PROMPT
  end
end
