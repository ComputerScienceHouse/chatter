import { Channel, Presence, Socket } from 'phoenix';
import { getUserId } from './user';

type PresenceObserver = (presences: object) => any;

export interface PresenceMeta {
    phx_ref: string;
    user_id: string;
}

let socket = new Socket('/socket', { params: {} });
let channel: Channel;
let initConfig = {};

let presences = {};
let presenceObservers: PresenceObserver[] = [] as PresenceObserver[];

socket.connect();

export function getSocket() {
    return socket;
}

export function subscribePresence(fn: PresenceObserver) {
    if (typeof fn !== 'function')
        throw 'attemped to register illegal object as an observer: ' + fn;
    presenceObservers.push(fn);
}

export function getPresences() {
    return presences;
}

export function getInitConfig() {
    return initConfig;
}

export function joinChannel(
    name: string,
    opts = {},
    fn?: (resp: object) => void
) {
    channel = socket.channel(name, { user_id: getUserId(), ...opts });

    channel
        .join()
        .receive('ok', (resp) => {
            initConfig = resp;
            console.log('connected to ' + name);
            if (fn) fn(resp);
        })
        .receive('error', (resp) => {
            console.log('failed to connect to ' + name, resp);
        });

    channel.on('presence_state', (state) => {
        presences = Presence.syncState(presences, state);
        presenceObservers.forEach((notify) => {
            notify(presences);
        });
    });

    channel.on('presence_diff', (diff) => {
        presences = Presence.syncDiff(presences, diff);
        presenceObservers.forEach((notify) => {
            notify(presences);
        });
    });
}

export function getChannel() {
    return channel;
}

export function channelOn(evt: string, fn: (resp: any) => void) {
    channel.on(evt, fn);
}

export function channelPush(evt: string, payload: object) {
    channel.push(evt, payload);
}
