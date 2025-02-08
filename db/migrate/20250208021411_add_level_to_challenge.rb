class AddLevelToChallenge < ActiveRecord::Migration[7.2]
  def change
    add_column :challenges, :level, :string
  end
end
