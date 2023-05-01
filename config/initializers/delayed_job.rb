Delayed::Worker.sleep_delay = 0.5

# Lower numbers run first
Delayed::Worker.queue_attributes = {
  parse_run: { priority: -1 },
  track: { priority: 10 },
}
