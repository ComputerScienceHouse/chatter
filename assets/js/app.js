import 'phoenix_html'; // Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import { Socket } from 'phoenix'; // Establish Phoenix Socket and LiveView configuration.
import { LiveSocket } from 'phoenix_live_view';

import './user_socket';

let csrfToken = document
    .querySelector("meta[name='csrf-token']")
    .getAttribute('content');
let liveSocket = new LiveSocket('/live', Socket, {
    params: { _csrf_token: csrfToken },
});

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;