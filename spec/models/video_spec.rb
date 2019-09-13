require 'rails_helper'

describe Video do
  context 'Twitch' do
    it 'recognizes Twitch.tv URLs' do
      valid_urls = [
        'https://twitch.tv/videos/12345678',
        'https://www.twitch.tv/videos/12345678'
      ]
      valid_urls.each { |url| expect(Video.new(url).twitch?).to be true }

      invalid_urls = [
        'https://witch.tv/videos/12345678',
        'https://www.snitch.tv/videos/12345678',
        'https://youtube.com/asdf1234'
      ]
      invalid_urls.each { |url| expect(Video.new(url).twitch?).to be false }
    end

    it 'extracts the video id from Twitch URLs' do
      urls = [
        'https://twitch.tv/videos/12345678',
        'https://www.twitch.tv/videos/12345678'
      ]
      urls.each { |url| expect(Video.new(url).id).to eq('12345678') }
    end
  end

  context 'YouTube' do
    it 'recognizes YouTube URLs' do
      valid_urls = [
        'https://www.youtube.com/watch?v=asdf1234&feature=related',
        'http://www.youtube.com/embed/watch?feature=player_embedded&v=asdf1234',
        'https://youtu.be/asdf1234'
      ]
      valid_urls.each { |url| expect(Video.new(url).youtube?).to be true }

      invalid_urls = [
        'https://www.metube.com/watch?v=asdf1234&feature=related',
        'https://sometube.com/asdf1234',
        'https://youto.be/asdf1234',
        'http://www.youtube.net/embed/watch?feature=player_embedded&v=asdf1234'
      ]
      invalid_urls.each { |url| expect(Video.new(url).youtube?).to be false }
    end

    it 'extracts the video id from YouTube URLs' do
      urls = [
        'https://www.youtube.com/watch?v=asdf1234&feature=related',
        'http://www.youtube.com/embed/watch?feature=player_embedded&v=asdf1234',
        'https://youtu.be/asdf1234'
      ]
      urls.each { |url| expect(Video.new(url).id).to eq('asdf1234') }
    end
  end

  context 'No URL' do
    it "doesn't require a URL in order to function" do
      video = Video.new
      expect(video.twitch?).to be false
      expect(video.youtube?).to be false
      expect(video.id).to be nil
    end
  end
end
