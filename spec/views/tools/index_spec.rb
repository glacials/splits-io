require 'rails_helper'

RSpec.describe 'tools/index' do
  let(:user) { FactoryBot.create(:user, :with_runs) }

  context 'with a non-gold account' do
    it 'renders the index template' do
      allow(view).to receive(:current_user).and_return(user)
      render

      expect(view).to render_template('tools/index')
    end
  end

  context 'with a gold account' do
    it 'renders the index template' do
      user.permagold = true
      allow(view).to receive(:current_user).and_return(user)
      render

      expect(view).to render_template('tools/index')
    end
  end
end
