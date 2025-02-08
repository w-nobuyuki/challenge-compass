import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["step", "progress"]

  connect() {
    this.currentStep = 0;
    // 全体のステップ数は、サービス説明ページ＋5つの入力ステップ（計6）なので、
    // 進捗は 0～(totalSteps - 1) で更新（最終ステップが100%）
    this.totalSteps = this.stepTargets.length - 1;
    this.showStep(this.currentStep, false);
    this.updateProgressBar();
  }

  showStep(index, animate = true) {
    this.stepTargets.forEach((element, i) => {
      if (i === index) {
        element.classList.remove("hidden");
        if (animate) {
          // 右から左にスライドするアニメーション
          element.classList.add("animate-slide-in");
          setTimeout(() => {
            element.classList.remove("animate-slide-in");
          }, 300);
        }
      } else {
        element.classList.add("hidden");
      }
    });
    this.updateProgressBar();
  }

  updateProgressBar() {
    let progressPercent = (this.currentStep / this.totalSteps) * 100;
    this.progressTarget.style.width = progressPercent + "%";
  }

  next(event) {
    event.preventDefault();
    if (this.currentStep < this.stepTargets.length - 1) {
      this.currentStep++;
      this.showStep(this.currentStep);
    }
  }

  prev(event) {
    event.preventDefault();
    if (this.currentStep > 0) {
      this.currentStep--;
      this.showStep(this.currentStep);
    }
  }
}
