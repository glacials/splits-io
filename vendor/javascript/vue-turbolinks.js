// vue-turbolinks@2.2.2 downloaded from https://ga.jspm.io/npm:vue-turbolinks@2.2.2/index.js

function handleVueDestruction(t){const e=t.$options.destroyEvent||defaultEvent();document.addEventListener(e,(function teardown(){t.$destroy();document.removeEventListener(e,teardown)}))}const t={beforeMount:function(){if(this===this.$root&&this.$el){handleVueDestruction(this);this.$cachedHTML=this.$el.outerHTML;this.$once("hook:destroyed",(function(){this.$el.parentNode&&(this.$el.outerHTML=this.$cachedHTML)}))}}};function plugin(e,n){e.mixin(t)}function defaultEvent(){return"undefined"!==typeof Turbo?"turbo:visit":"turbolinks:visit"}export default plugin;export{t as turbolinksAdapterMixin};

