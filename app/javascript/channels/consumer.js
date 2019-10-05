// Action Cable provides the framework to deal with WebSockets in Rails.
// You can generate new channels where WebSocket features live using the `rails generate channel` command.

import { createConsumer } from "@rails/actioncable"
import { getAccessToken } from '../token'

const consumer = createConsumer(getWebsocketURL)

function getWebsocketURL() {
  const token = getAccessToken()
  let url = '/api/cable'
  if (token) {
    url += `?access_token=${token}`
  }

  return url

}

export default consumer
