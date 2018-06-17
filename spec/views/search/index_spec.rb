require 'rails_helper'

RSpec.describe 'search/index' do
  context 'with no results' do
    it 'renders the index template' do
      assign(:results, {})
      render

      expect(view).to render_template('search/index')
    end
  end

  context 'with games and users results' do
    it 'renders the index template' do
      assign(
        :results,
        games: [FactoryBot.create_list(:game, 5, :with_categories, :with_runs)],
        users: [FactoryBot.create_list(:user, 5, :with_runs)]
      )
    end
  end
end
