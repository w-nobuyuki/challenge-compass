class Task < ApplicationRecord
  belongs_to :user
  has_many :challenges, dependent: :destroy
  has_one :feedback, dependent: :destroy
end
