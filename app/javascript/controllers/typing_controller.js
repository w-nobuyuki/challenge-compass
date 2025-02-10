import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["output"]  // タイピング結果を表示する要素
  static values = {
    text: String,  // タイピングする元の文字列
    speed: { type: Number, default: 50 } // 1文字表示ごとの間隔(ミリ秒)
  }

  connect() {
    this.index = 0
    // 出力先を一旦空にする
    this.outputTarget.textContent = ""
    // タイピング開始
    this.typeNextLetter()
  }

  typeNextLetter() {
    console.log("textValue" & this.textValue)
    console.log("speedValue" & this.speedValue)
    if (this.index < this.textValue.length) {
      // テキストを1文字追加
      this.outputTarget.textContent += this.textValue.charAt(this.index)
      this.index++

      // speedValueミリ秒後に次の文字を表示
      setTimeout(() => this.typeNextLetter(), this.speedValue)
    }
  }
}
