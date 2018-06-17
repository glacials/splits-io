require 'rails_helper'

RSpec.describe 'games/categories/_title' do
  let(:category) { FactoryBot.build(:category, :with_runs) }

  it 'renders the title template' do
    assign(:category, category)
    assign(:game, category.game)
    render

    expect(view).to render_template('games/categories/_title')
  end
end
