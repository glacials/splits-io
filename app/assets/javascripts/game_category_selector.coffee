window.update_category_selector = (game_shortname) ->
  $('#game_category_submit').attr('disabled', true)
  $.get('/api/v3/games/' + game_shortname).success (res) ->
    $('#run_category').empty()
    $.each(res.game.categories, (_, category) ->
      $('#run_category').append(
        $('<option></option>').attr('value', category.id).text(category.name)
      )
    )
    $('#game_category_submit').attr('disabled', false)
