require 'rails_helper'

RSpec.describe 'games/edit' do
  it 'renders the edit template' do
    assign(:game, FactoryBot.create(:game))
    render

    expect(view).to render_template('games/edit')
  end
end
