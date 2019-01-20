import tippy from "tippy.js"

document.addEventListener('turbolinks:load', function() {
  tippy('.gold-split', {placement: 'left'})
  tippy('.tip', {placement: 'top'})
  tippy('.tip-top', {placement: 'top'})
  tippy('.tip-bottom', {placement: 'bottom'})
  tippy('.tip-right', {placement: 'right'})
  tippy('.tip-left', {placement: 'left'})
})
