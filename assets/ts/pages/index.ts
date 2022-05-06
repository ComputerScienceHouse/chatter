import OnlineUsersComponent from '../components/online-users/online-users';
import ChatComponent from '../components/chat/chat';
import { joinChannel } from '../util/socket';

joinChannel('space:lobby', {}, () => {
    new OnlineUsersComponent().render('#online-users');
    new ChatComponent().render('#chat-component');
});
