import { genRandomID } from '../util/rand';

export default abstract class Component {
  protected COMPONENT_ID: string;

  constructor() {
    this.COMPONENT_ID = genRandomID();
  }

  id(name: string) {
    return name + '-' + this.COMPONENT_ID;
  }

  render(selector: string): void {
    document.querySelector(
      selector
    ).innerHTML = `<div id="${this.COMPONENT_ID}"></div>`;
  }
}
