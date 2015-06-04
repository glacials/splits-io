module RivalriesHelper

  BUTT_KICK_SENTENCES = [
    "kick their butt",
    "kick a butt",
    "gently connect a foot with a butt",
    "do some butt kicking",
    "shove your foot at their butt",
    "activate the butt-kick-a-tron 3000",
    "kick all the butts",
    "never stop kicking butts",
    "connect your foot with their butt",
    "connect their butt with your foot",
    "kick kick kick kick kick kick"
  ]

  def next_butt_kick_sentence
    @next_index = ((@next_index || -1) + 1) % BUTT_KICK_SENTENCES.length
    BUTT_KICK_SENTENCES[@next_index]
  end

  def rival_display_info(rivalry)
    if rivalry.nil?
      {
        avatar: 'https://static-cdn.jtvnw.net/jtv_user_pictures/xarth/404_user_150x150.png',
        name: '???',
        pb: '???',
        sum_of_best: '???'
      }
    else
      {
        avatar: rivalry.to_user.avatar,
        name: rivalry.to_user.name,
        pb: rivalry.to_user.pb_for(rivalry.category).time,
        sum_of_best: rivalry.to_user.pb_for(rivalry.category).sum_of_best
      }
    end
  end
end
