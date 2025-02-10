import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  // モーダルを閉じたらroot_pathに移動させる

  close() {
    // モーダル要素を削除する or 非表示化してからredirect
    // ここではTurboを使ってroot_pathへ
    Turbo.visit("/")
  }

  // Escapeキー押下で閉じる例（オプショナル）
  handleKeydown(event) {
    if (event.key === "Escape") {
      this.close()
    }
  }
}
