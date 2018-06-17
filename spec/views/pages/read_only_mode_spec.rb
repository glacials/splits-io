require 'rails_helper'

RSpec.describe 'pages/read_only_mode' do
  it 'renders the read only mode page' do
    render

    expect(view).to render_template('pages/read_only_mode')
  end
end
