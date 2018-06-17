require 'rails_helper'

RSpec.describe 'why/darkmode' do
  it 'renders the darkmode template' do
    render

    expect(view).to render_template('why/darkmode')
  end
end
