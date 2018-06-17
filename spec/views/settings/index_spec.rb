require 'rails_helper'

RSpec.describe 'settings/index' do
  let(:user) { FactoryBot.create(:user, :with_runs) }

  context 'when logged out' do
    it 'renders the index template' do
      allow(view).to receive(:current_user).and_return(nil)
      render

      expect(view).to render_template('settings/index')
    end
  end

  context 'when logged in' do
    it 'renders the index template' do
      allow(view).to receive(:current_user).and_return(user)
      render

      expect(view).to render_template('settings/index')
    end
  end
end
