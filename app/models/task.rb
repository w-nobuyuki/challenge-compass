class Task < ApplicationRecord
  belongs_to :user
  has_many :challenges, dependent: :destroy
  has_one :feedback, dependent: :destroy

  accepts_nested_attributes_for :challenges

  scope :today, -> { where(date: Date.today) }

  def today?
    date == Date.today
  end
end
