require 'rails_helper'

RSpec.describe 'games/categories/leaderboards/sum_of_bests/index' do
  it 'renders the index template' do
    assign(:game, FactoryGirl.create(:game))
    assign(:category, FactoryGirl.create(:category))
    render

    expect(view).to render_template('games/categories/leaderboards/sum_of_bests/index')
  end
end
