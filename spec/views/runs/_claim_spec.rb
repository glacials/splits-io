require 'rails_helper'

RSpec.describe 'runs/_claim' do
  let(:user) { FactoryBot.create(:user) }

  context 'when logged out' do
    it 'renders the claim template' do
      allow(view).to receive(:current_user).and_return(nil)
      render

      expect(view).to render_template('runs/_claim')
    end
  end

  context 'when logged in' do
    it 'renders the claim template' do
      allow(view).to receive(:current_user).and_return(user)
      render

      expect(view).to render_template('runs/_claim')
    end
  end
end
