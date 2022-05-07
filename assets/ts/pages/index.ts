import OnlineUsersComponent from '../components/online-users/online-users';
import ChatComponent from '../components/chat/chat';
import SpacesComponent from '../components/spaces/spaces';
import { joinChannel } from '../util/socket';

joinChannel('space:lobby', {}, () => {
  new OnlineUsersComponent().render('#online-users');
  new ChatComponent().render('#chat-component');
  new SpacesComponent().render('#spaces-component');
});
