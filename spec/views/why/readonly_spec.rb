require 'rails_helper'

RSpec.describe 'why/readonly' do
  it 'renders the darkmode readonly' do
    render

    expect(view).to render_template('why/readonly')
  end
end
