// Action Cable provides the framework to deal with WebSockets in Rails.
// You can generate new channels where WebSocket features live using the `rails generate channel` command.

import { createConsumer } from "@rails/actioncable"

import { accessTokenKey } from '../token'

function getWebsocketURL() {
  const token = localStorage.getItem(accessTokenKey)
  let url = '/cable'
  if (token) {
    url += `?access_token=${token}`
  }

  return url

}

export default createConsumer(getWebsocketURL)
