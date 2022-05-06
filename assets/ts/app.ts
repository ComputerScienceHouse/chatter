import 'phoenix_html'; // Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import { Socket } from 'phoenix'; // Establish Phoenix Socket and LiveView configuration.
import { LiveSocket } from 'phoenix_live_view';

import '../css/app.css'; // tell esbuild to bundle css as well

let csrfToken = document
    .querySelector("meta[name='csrf-token']")
    .getAttribute('content');
let liveSocket = new LiveSocket('/live', Socket, {
    params: { _csrf_token: csrfToken },
});

// I swear I like TS, even when it pulls this shennaigans
declare global {
    interface Window {
        liveSocket: LiveSocket;
    }
}

liveSocket.connect();
window.liveSocket = liveSocket;
