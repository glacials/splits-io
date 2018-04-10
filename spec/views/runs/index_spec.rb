require 'rails_helper'

RSpec.describe 'runs/index' do
  it 'renders the index template' do
    render

    expect(view).to render_template('runs/index')
  end
end
