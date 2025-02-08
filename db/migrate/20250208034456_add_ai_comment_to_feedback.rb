class AddAiCommentToFeedback < ActiveRecord::Migration[7.2]
  def change
    add_column :feedbacks, :ai_comment, :text
  end
end
