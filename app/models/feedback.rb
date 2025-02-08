class Feedback < ApplicationRecord
  belongs_to :task

  attribute :challenge_feedbacks
end
