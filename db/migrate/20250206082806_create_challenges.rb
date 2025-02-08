class CreateChallenges < ActiveRecord::Migration[7.2]
  def change
    create_table :challenges do |t|
      t.references :task, null: false, foreign_key: true
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
