const setupGA = () => {
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga')
  ga('create', 'UA-2876079-8', 'auto')
}

document.addEventListener('turbolinks:load', () => {
  if (typeof(ga) !== 'function') {
    setupGA()
  }
  const controller = document.body.dataset['controller']
  const action = document.body.dataset['action']

  // If we're at a path like "/users/glacials" the path we actually want to sent to Google Analytics is "/users/:user"
  switch (controller) {
    case 'runs':
      switch (action) {
        case 'show':
          ga('set', 'page', '/:run')
          break
        case 'edit':
          ga('set', 'page', '/:run/edit')
          break
      }
      break
    case 'stats':
      switch (action) {
        case 'index':
          ga('set', 'page', '/:run/stats')
          break
      }
      break
    case 'games':
      switch(action) {
        case 'show':
          ga('set', 'page', '/games/:game')
          break
        case 'edit':
          ga('set', 'page', '/games/:game/edit')
          break
      }
      break
    case 'users':
      switch(action) {
        case 'show':
          ga('set', 'page', '/users/:user')
          break
      }
      break
    case 'categories':
      switch(action) {
        case 'show':
          ga('set', 'page', '/games/:game/categories/:category')
          break
      }
      break
    case 'sum_of_bests':
      switch(action) {
        case 'index':
          ga('set', 'page', '/games/:game/categories/:category/leaderboards/sum_of_bests')
          break
      }
      break
    case 'rivalries':
      switch(action) {
        case 'index':
          ga('set', 'page', '/users/:user/rivalries')
          break
        case 'new':
          ga('set', 'page', '/users/:user/rivalries/new')
          break
      }
      break
    default:
      ga('set', 'page', window.location.pathname)
  }

  ga('send', 'pageview')
})

// Segment
!function(){var analytics=window.analytics=window.analytics||[];if(!analytics.initialize)if(analytics.invoked)window.console&&console.error&&console.error("Segment snippet included twice.");else{analytics.invoked=!0;analytics.methods=["trackSubmit","trackClick","trackLink","trackForm","pageview","identify","reset","group","track","ready","alias","debug","page","once","off","on"];analytics.factory=function(t){return function(){var e=Array.prototype.slice.call(arguments);e.unshift(t);analytics.push(e);return analytics}};for(var t=0;t<analytics.methods.length;t++){var e=analytics.methods[t];analytics[e]=analytics.factory(e)}analytics.load=function(t,e){var n=document.createElement("script");n.type="text/javascript";n.async=!0;n.src="https://cdn.segment.com/analytics.js/v1/"+t+"/analytics.min.js";var a=document.getElementsByTagName("script")[0];a.parentNode.insertBefore(n,a);analytics._loadOptions=e};analytics.SNIPPET_VERSION="4.1.0";
analytics.load("yeTaODeLu7JrWMx4y0tHK1JWxlA40luU");
analytics.page();
}}();
