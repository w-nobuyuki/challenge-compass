class AddFeedbackToChallenge < ActiveRecord::Migration[7.2]
  def change
    add_column :challenges, :feedback, :string
  end
end
