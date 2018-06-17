require 'rails_helper'

RSpec.describe 'applications/forbidden' do
  it 'renders the forbidden template' do
    render

    expect(view).to render_template('applications/forbidden')
  end
end
