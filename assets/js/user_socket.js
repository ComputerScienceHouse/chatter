import { Socket, Presence } from 'phoenix';

function getUserId() {
    const params = new URLSearchParams(window.location.search);
    return (
        params.get('spoof') ??
        document.getElementById('user-info').dataset.id ??
        'unset'
    );
}

const socket = new Socket('/socket', { params: {} });

socket.connect();

const channel = socket.channel('room:42', { user_id: getUserId() });

channel
    .join()
    .receive('ok', (resp) => {
        console.log('yuh!', resp);
    })
    .receive('error', (resp) => {
        console.log(
            "oooof-- couldn't connect. check admin dashboard & socket status?",
            resp
        );
    });

channel.on('announce', (resp) => console.log(resp));

let presences = {};

channel.on('presence_state', (state) => {
    presences = Presence.syncState(presences, state);
    renderOnlineUsers();
});

channel.on('presence_diff', (diff) => {
    presences = Presence.syncDiff(presences, diff);
    renderOnlineUsers(presences);
});

function renderOnlineUsers(presences) {
    let onlineUsers = Presence.list(presences, (_id, obj) => {
        if (!obj) return ''; // skip

        const {
            metas: [user, ..._rest],
        } = obj;
        return onlineUserTemplate(user);
    }).join('');

    document.querySelector('#online-users').innerHTML = onlineUsers;
}

function onlineUserTemplate(user) {
    return `
        <li class="list-group-item d-flex align-items-center p-0">
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

export default socket;
