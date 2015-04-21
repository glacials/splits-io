$(function () {
  $('.time').each(function (i, el) {
    if ($.trim(el.innerHTML) === '0') {
      el.innerHTML = '-';
    } else {
      el.innerHTML = numeral(Math.floor(el.innerHTML)).format('00:00:00');
    }
  });
});
