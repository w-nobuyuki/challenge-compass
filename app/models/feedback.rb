class Feedback < ApplicationRecord
  belongs_to :task

  attribute :mentor
end
