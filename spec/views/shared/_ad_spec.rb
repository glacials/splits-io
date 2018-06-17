require 'rails_helper'

RSpec.describe 'shared/_ad' do
  context 'while logged out' do
    before { allow(view).to receive(:current_user).and_return(nil) }

    it 'renders the ad template' do
      render

      expect(view).to render_template('shared/_ad')
    end
  end

  context 'while logged into a non-gold account' do
    before { allow(view).to receive(:current_user).and_return(FactoryBot.build(:user)) }

    it 'renders the ad template' do
      render

      expect(view).to render_template('shared/_ad')
    end
  end

  context 'while logged into a gold account' do
    before { allow(view).to receive(:current_user).and_return(FactoryBot.build(:user, permagold: true)) }

    it 'renders the ad template' do
      render

      expect(view).to render_template('shared/_ad')
    end
  end
end
