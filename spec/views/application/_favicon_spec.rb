require 'rails_helper'

RSpec.describe 'application/_favicon' do
  it 'renders the favicon template' do
    render

    expect(view).to render_template('application/_favicon')
  end
end
