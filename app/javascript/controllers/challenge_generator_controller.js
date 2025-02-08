import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay", "challengeList", "confirmButton"]

  generate(event) {
    event.preventDefault();
    // ローディングオーバーレイを表示
    this.overlayTarget.classList.remove("hidden");

    // フォームのデータを収集
    const form = document.getElementById("task-form");
    const formData = new FormData(form);

    // tasks_controller の generate_challenges アクションに POST リクエストを送信
    fetch("/tasks/generate_challenges", {
      method: "POST",
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute("content")
      },
      body: formData
    })
    .then(response => {
      if (!response.ok) { throw new Error("Network response was not ok"); }
      return response.text();
    })
    .then(html => {
      // 受け取ったチャレンジ一覧の HTML を表示エリアに挿入
      this.challengeListTarget.innerHTML = html;

      // ローディングオーバーレイを非表示に
      this.overlayTarget.classList.add("hidden");

      // チャレンジ確定ボタンを表示
      this.confirmButtonTarget.classList.remove("hidden");

      // チャレンジ一覧の位置までスムーズスクロール
      this.challengeListTarget.scrollIntoView({ behavior: "smooth" });
    })
    .catch(error => {
      console.error("Error generating challenges:", error);
      this.overlayTarget.classList.add("hidden");
      alert("チャレンジ生成中にエラーが発生しました。もう一度お試しください。");
    });
  }
}
