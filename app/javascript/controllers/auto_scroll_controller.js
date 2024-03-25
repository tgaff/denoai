import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="auto-scroll"
export default class extends Controller {
  connect() {
    console.log('a connection')
    const observer = new MutationObserver(() => {
      this.scrollDown(); // Scroll down when mutations occur
    });

    observer.observe(this.element, {
      childList: true,
      subtree: true
    });

  }

  scrollDown() {
    this.element.scrollTop = this.element.scrollHeight;
  }
}
