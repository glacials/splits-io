const timesync = require('timesync/dist/timesync')

let ts

ts = timesync.create({
  server: '/api/v4/timesync',
  // 10 minute refresh interval
  interval: 10 * 60 * 1000
})

export { ts }
