// app/javascript/controllers/loading_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay"]

  connect() {
    // Turbo のイベントを監視して、送信開始時に表示、完了時に非表示にする
    document.addEventListener("turbo:submit-start", this.showOverlay)
    document.addEventListener("turbo:before-fetch-request", this.showOverlay)

    document.addEventListener("turbo:submit-end", this.hideOverlay)
    document.addEventListener("turbo:before-fetch-response", this.hideOverlay)
  }

  disconnect() {
    document.removeEventListener("turbo:submit-start", this.showOverlay)
    document.removeEventListener("turbo:before-fetch-request", this.showOverlay)

    document.removeEventListener("turbo:submit-end", this.hideOverlay)
    document.removeEventListener("turbo:before-fetch-response", this.hideOverlay)
  }

  showOverlay = () => {
    this.overlayTarget.classList.remove("hidden")
  }

  hideOverlay = () => {
    this.overlayTarget.classList.add("hidden")
  }
}
