import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

// Connects to data-controller="select-fetch"
export default class extends Controller {
  connect() {
    console.log('yo')
  }

  change() {
    const selectedLibraryId = this.element.value;
    const frameId = this.element.getAttribute("data-frame-id");
    const url = this.element.getAttribute("data-url");

    if (selectedLibraryId && frameId && url) {
      Turbo.visit(`${url}/${selectedLibraryId}`, { frame: frameId });
    }
  }
}
