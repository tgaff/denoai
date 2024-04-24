import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

// Connects to data-controller="select-fetch"
// Navigates to a URL defined by a template such as `/foo/:id`
export default class extends Controller {

  static values = {
    url: String, // a template for the URL: :id will be replaced with the value of this controller's elem
    frameId: String // used to determine which turbo-frame to load the fetch into
  }

  connect() {
    console.log('select-fetch connect');
  }

  change() {
    const selectedLibraryId = this.element.value;    
    const frameId = this.frameIdValue;
    const url = this.composeURL();
    
    if (selectedLibraryId && frameId && url) {
      Turbo.visit(url, { action: 'replace', frame: frameId });
    }
  }

  composeURL() {
    return this.urlValue.replace(':id', this.element.value)
  }
}
