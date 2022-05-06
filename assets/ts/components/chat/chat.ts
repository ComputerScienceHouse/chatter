import './chats.css';

import Component from '../component';
import { channelOn, channelPush, getInitConfig } from '../../util/socket';

export default class ChatComponent extends Component {
    renderChat(chat: { msg: string; user_id: string }) {
        document
            .getElementById(this.COMPONENT_ID)
            .querySelector(
                '.card-body > .chats'
            ).innerHTML += `<div>${chat.user_id}: ${chat.msg}</div>`;

        this.scrollToBottom();
    }

    scrollToBottom() {
        document.querySelector(`#${this.COMPONENT_ID} .chats`).scrollTo({
            top: 999999,
            behavior: 'smooth',
        });
    }

    render(selector: string) {
        document.querySelector(selector).innerHTML = `
            <div class="card bd-light mb-4" id="${this.COMPONENT_ID}">
                <div class="card-header">
                    <h3 class="card-title spaces-header">Chat</h3>
                </div>
                <div class="card-body">
                    <div class="chats">
                    </div>
                    <form class="form-inline" id="frm-chat">
                        <input id="tb-msg" class="form-control" style="width: 100%" type="text" placeholder="message #lobby">
                    </form>
                </div>
            </div>
        `;

        document.getElementById('frm-chat').addEventListener('submit', (e) => {
            e.preventDefault();
            const msgInput = document.getElementById(
                'tb-msg'
            ) as HTMLInputElement;

            channelPush('msg:post', { msg: msgInput.value });
            msgInput.value = '';
        });

        channelOn('msg:new', (resp) => {
            this.renderChat(resp);
        });

        (getInitConfig() as any).chats
            ?.reverse()
            .forEach(this.renderChat.bind(this));
    }
}
