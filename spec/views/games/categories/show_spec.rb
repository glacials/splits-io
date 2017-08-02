require 'rails_helper'


RSpec.describe 'games/categories/show' do
  it 'renders the show template' do
    assign(:game, FactoryGirl.create(:game))
    assign(:category, FactoryGirl.create(:category))
    render

    expect(view).to render_template('games/categories/show')
  end
end
