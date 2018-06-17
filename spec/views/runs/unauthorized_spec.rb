require 'rails_helper'

RSpec.describe 'runs/unauthorized' do
  it 'renders the unauthorized template' do
    render

    expect(view).to render_template('runs/unauthorized')
  end
end
