$ ->
  $('.left-nav a, .right-nav a').hover ->
    $('.splash').css('background-color': $(this).css('background-color'))
  , ->
    $('.splash').css('background-color': $('.left-nav > a').first().css('color'))
