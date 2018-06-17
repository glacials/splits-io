require 'rails_helper'

RSpec.describe 'games/not_found' do
  it 'renders the not_found template' do
    render

    expect(view).to render_template('games/not_found')
  end
end
