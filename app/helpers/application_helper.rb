# app/helpers/application_helper.rb
module ApplicationHelper
  def flash_class(type)
    case type.to_sym
    when :notice
      # 情報メッセージ用（青背景など）
      "bg-blue-100 border border-blue-400 text-blue-700 px-4 py-3 rounded relative my-3"
    when :alert
      # 警告・失敗メッセージ用（赤背景など）
      "bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative my-3"
    when :success
      # 成功メッセージ用（緑背景など）
      "bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative my-3"
    else
      # その他
      "bg-gray-100 border border-gray-400 text-gray-700 px-4 py-3 rounded relative my-3"
    end
  end
end
