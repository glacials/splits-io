require 'rails_helper'

RSpec.describe 'rivalries/index' do
  it 'renders the index template' do
    assign(:rivalries, [FactoryBot.create(:rivalry)])
    render

    expect(view).to render_template('rivalries/index')
  end
end
