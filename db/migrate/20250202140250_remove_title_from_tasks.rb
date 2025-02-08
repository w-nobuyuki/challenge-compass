class RemoveTitleFromTasks < ActiveRecord::Migration[7.2]
  def change
    remove_column :tasks, :title, :string
  end
end
