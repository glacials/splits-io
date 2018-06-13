module RivalriesHelper
  BUTT_KICK_SENTENCES = %q[
    'kick their butt'
    'kick a butt'
    'gently connect a foot with a butt'
    'do some butt kicking'
    'shove your foot at their butt'
    'activate the butt-kick-a-tron 3000'
    'kick all the butts'
    'never stop kicking butts'
    'connect your foot with their butt'
    'connect their butt with your foot'
    'kick kick kick kick kick kick'
  ].freeze

  def next_butt_kick_sentence
    @next_index = ((@next_index || -1) + 1) % BUTT_KICK_SENTENCES.length
    BUTT_KICK_SENTENCES[@next_index]
  end
end
