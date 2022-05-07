import './online-users.css';

import { Presence } from 'phoenix';
import { getUserId } from '../../util/user';
import { subscribePresence, PresenceMeta } from '../../util/socket';
import Component from '../component';

export default class OnlineUsersComponent extends Component {
  renderOnlineUsers(presences: object) {
    document.getElementById('online-users-' + this.COMPONENT_ID).innerHTML =
      Presence.list(presences, (_id, obj: { metas: PresenceMeta[] }) => {
        if (!obj) return ''; // skip

        // typically, only one meta will exist per presence record //

        const {
          metas: [user, ..._],
        } = obj;
        return this.onlineUserTemplate(user);
      }).join('');
  }

  onlineUserTemplate(user: PresenceMeta) {
    return `
        <li class="list-group-item online-user d-flex align-items-center p-0">
            <a class="nav-link" href="https://profiles.csh.rit.edu/user/${
              user.user_id
            }" style="padding: 0.5rem">
                <img src="https://profiles.csh.rit.edu/image/${
                  user.user_id
                }" style="width: 2rem; height: 2rem; border-radius: 50%; margin-radius: 0.3rem;">
                &nbsp;${user.user_id}
            </a>
                ${
                  user.user_id === getUserId()
                    ? ' <span class="badge badge-primary">me</span>'
                    : ''
                }
        </li>
    `;
  }

  render(selector: string) {
    document.querySelector(selector).innerHTML = `
            <div class="card bd-light mb-4" id="${this.COMPONENT_ID}">
                <div class="card-header">
                    <h3 class="card-title online-users-header">Online</h3>
                </div>
                <div class="card-body online-users-card-body">
                    <div id="online-users-${this.COMPONENT_ID}"></div>
                </div>
            </div>
        `;

    subscribePresence(this.renderOnlineUsers.bind(this));
  }
}
