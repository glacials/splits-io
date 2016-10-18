window.update_category_selector = (game_shortname) ->
  $('#game_category_submit').attr('disabled', true)
  $.get('/api/v3/games/' + game_shortname).success (res) ->
    el = $('#' + gon.run.id + '_category')
    el.empty()
    $.each(res.game.categories, (_, category) ->
      el.append(
        $('<option></option>').attr('value', category.id).text(category.name)
      )
    )
    $('#game_category_submit').attr('disabled', false)
