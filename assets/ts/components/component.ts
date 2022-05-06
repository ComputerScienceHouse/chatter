import { genRandomID } from '../util/rand';

export default abstract class Component {
    protected COMPONENT_ID: string;

    constructor() {
        this.COMPONENT_ID = genRandomID();
    }

    render(selector: string): void {
        document.querySelector(
            selector
        ).innerHTML = `<div id="${this.COMPONENT_ID}"></div>`;
    }
}
