require 'rails_helper'

RSpec.describe 'shared/_favicons' do
  it 'renders the favicons template' do
    render

    expect(view).to render_template('shared/_favicons')
  end
end
