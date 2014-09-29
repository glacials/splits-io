mixpanel.track("viewed a page", {"URL": window.location.pathname});
mixpanel.track_links("#sign-in",  "signed in");
mixpanel.track_links("#sign-out", "signed out");
mixpanel.track_links("#disown", "disowned a run");
mixpanel.track_links("#delete", "deleted a run");
mixpanel.track_links("#twitch-channel", "visited a twitch channel", {
  channel: gon.run.user.name,
  game: gon.run.game.name,
  category: gon.run.category.name,
  program: gon.run.program
});
mixpanel.track_forms("#search", "searched");
