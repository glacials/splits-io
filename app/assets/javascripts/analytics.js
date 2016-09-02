$(function() {
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
  ga('create', 'UA-2876079-8', 'auto');

  var controller = $('body').data('controller');
  var action = $('body').data('action');

  // If we're at a path like "/users/glacials" the path we actually want to sent to Google Analytics is "/users/:user"
  switch (controller) {
    case 'runs':
      switch (action) {
        case 'show':
          ga('set', 'page', '/:run');
          break;
        case 'edit':
          ga('set', 'page', '/:run/edit');
          break;
      }
      break;
    case 'stats':
      switch (action) {
        case 'index':
          ga('set', 'page', '/:run/stats');
          break;
      }
      break;
    case 'games':
      switch(action) {
        case 'show':
          ga('set', 'page', '/games/:game');
          break;
        case 'edit':
          ga('set', 'page', '/games/:game/edit');
          break;
      }
      break;
    case 'users':
      switch(action) {
        case 'show':
          ga('set', 'page', '/users/:user');
          break;
      }
      break;
    case 'categories':
      switch(action) {
        case 'show':
          ga('set', 'page', '/games/:game/categories/:category');
          break;
      }
      break;
    case 'sum_of_bests':
      switch(action) {
        case 'index':
          ga('set', 'page', '/games/:game/categories/:category/leaderboards/sum_of_bests');
          break;
      }
      break;
    case 'rivalries':
      switch(action) {
        case 'index':
          ga('set', 'page', '/users/:user/rivalries');
          break;
        case 'new':
          ga('set', 'page', '/users/:user/rivalries/new');
          break;
      }
      break;
    default:
      ga('set', 'page', event.data.path);
  };

  ga('send', 'pageview');
});
