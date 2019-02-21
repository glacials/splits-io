require 'rails_helper'

describe Video, type: :model do
  context 'with a valid video URL' do
    let(:video) { FactoryBot.build(:video) }

    it 'successfully validates' do
      expect(video).to be_valid
    end
  end

  context 'with a valid video URL to a non-valid location' do
    let(:video) { FactoryBot.build(:video, url: 'http://google.com/') }

    it 'fails to validate' do
      expect(video).not_to be_valid
    end
  end

  context 'with an invalid video URL' do
    let(:video) do
      FactoryBot.build(:video, url: 'Huge improvement. That King Boo fight tho... :/ 4 HP strats!')
    end

    it 'fails to validate' do
      expect(video).not_to be_valid
    end
  end
end
