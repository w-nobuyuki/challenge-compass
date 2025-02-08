class AddDateToTask < ActiveRecord::Migration[7.2]
  def change
    add_column :tasks, :date, :date, null: false
  end
end
