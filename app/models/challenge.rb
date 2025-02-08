class Challenge < ApplicationRecord
  extend Enumerize

  belongs_to :task

  enumerize :level, in: [ :low, :medium, :high ]
  enumerize :feedback, in: [ :very_bad, :bad, :average, :good, :very_good ]
end
