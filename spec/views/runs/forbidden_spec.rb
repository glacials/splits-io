require 'rails_helper'

RSpec.describe 'runs/forbidden' do
  it 'renders the forbidden template' do
    render

    expect(view).to render_template('runs/forbidden')
  end
end
