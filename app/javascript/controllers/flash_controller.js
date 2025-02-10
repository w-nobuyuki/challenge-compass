// app/javascript/controllers/dismiss_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  close() {
    this.element.remove()
  }
}
