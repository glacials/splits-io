require 'rails_helper'

RSpec.describe 'subscriptions/index' do
  it 'renders the index template' do
    render

    expect(view).to render_template('subscriptions/index')
  end
end
