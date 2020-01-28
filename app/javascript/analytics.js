document.addEventListener('turbolinks:load', () => {
  // Segment
  !function(){var analytics=window.analytics=window.analytics||[];if(!analytics.initialize)if(analytics.invoked)window.console&&console.error&&console.error("Segment snippet included twice.");else{analytics.invoked=!0;analytics.methods=["trackSubmit","trackClick","trackLink","trackForm","pageview","identify","reset","group","track","ready","alias","debug","page","once","off","on"];analytics.factory=function(t){return function(){var e=Array.prototype.slice.call(arguments);e.unshift(t);analytics.push(e);return analytics}};for(var t=0;t<analytics.methods.length;t++){var e=analytics.methods[t];analytics[e]=analytics.factory(e)}analytics.load=function(t,e){var n=document.createElement("script");n.type="text/javascript";n.async=!0;n.src="https://cdn.segment.com/analytics.js/v1/"+t+"/analytics.min.js";var a=document.getElementsByTagName("script")[0];a.parentNode.insertBefore(n,a);analytics._loadOptions=e};analytics.SNIPPET_VERSION="4.1.0";
  analytics.load("yeTaODeLu7JrWMx4y0tHK1JWxlA40luU")
  analytics.page(`${document.body.dataset['controller']} ${document.body.dataset['action']}`)

  if (gon.user) {
    analytics.identify(gon.user.id, {
      createdAt: gon.user.created_at,
      name: gon.user.name,
      email: gon.user.email,
      plan: gon.user.plan,
      num_runs: gon.user.num_runs,
    })
  }
  }}()
})
