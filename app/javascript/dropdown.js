// Keep dropdowns open when clicked if the clicked element has class .keep-open-on-click
// from https://stackoverflow.com/a/52692312/392225
$(document).on('click.bs.dropdown.data-api', '.dropdown .keep-open-on-click', (event) => {
  event.stopPropagation();
});
