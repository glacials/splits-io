require 'rails_helper'

RSpec.describe 'runs/cant_parse' do
  it 'renders the cant_parse template' do
    render

    expect(view).to render_template('runs/cant_parse')
  end
end
