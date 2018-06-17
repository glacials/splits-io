require 'rails_helper'

RSpec.describe 'converts/new' do
  it 'renders the new template' do
    render

    expect(view).to render_template('converts/new')
  end
end
