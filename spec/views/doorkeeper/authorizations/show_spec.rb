require 'rails_helper'

RSpec.describe 'doorkeeper/authorizations/show' do
  it 'renders the show template' do
    render

    expect(view).to render_template('doorkeeper/authorizations/show')
  end
end
