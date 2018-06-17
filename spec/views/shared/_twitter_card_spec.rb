require 'rails_helper'

RSpec.describe 'shared/_twitter_card' do
  context 'with no run' do
    it 'renders the twitter card' do
      render

      expect(view).to render_template('shared/_twitter_card')
    end
  end

  context 'with a run' do
    let(:run) { FactoryBot.create(:run) }

    it 'renders the twitter card' do
      render

      expect(view).to render_template('shared/_twitter_card')
    end
  end
end
