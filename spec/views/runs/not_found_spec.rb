require 'rails_helper'

RSpec.describe 'runs/not_found' do
  it 'renders the not_found template' do
    render

    expect(view).to render_template('runs/not_found')
  end
end
