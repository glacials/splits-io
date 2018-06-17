require 'rails_helper'

RSpec.describe 'pages/faq' do
  it 'renders the faq page' do
    render

    expect(view).to render_template('pages/faq')
  end
end
