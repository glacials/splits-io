require 'rails_helper'

RSpec.describe 'tools/index' do
  context 'with a normal account' do
    before { allow(view).to receive(:current_user).and_return(FactoryBot.build(:user)) }

    it 'renders the index template' do
      render

      expect(view).to render_template('tools/index')
    end
  end

  context 'with a patron account' do
    before { allow(view).to receive(:current_user).and_return(FactoryBot.build(:patreon_user, pledge_cents: 600).user) }

    it 'renders the index template' do
      render

      expect(view).to render_template('tools/index')
    end
  end
end
