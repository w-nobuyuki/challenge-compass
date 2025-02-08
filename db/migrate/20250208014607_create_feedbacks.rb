class CreateFeedbacks < ActiveRecord::Migration[7.2]
  def change
    create_table :feedbacks do |t|
      t.references :task, null: false, foreign_key: true
      t.text :comment

      t.timestamps
    end
  end
end
