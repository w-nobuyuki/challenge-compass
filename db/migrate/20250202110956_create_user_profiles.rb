class CreateUserProfiles < ActiveRecord::Migration[7.2]
  def change
    create_table :user_profiles do |t|
      t.string :goal
      t.text :description
      t.text :background
      t.text :current_job
      t.text :gap_between_goal
      t.string :period
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
