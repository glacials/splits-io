require 'rails_helper'

RSpec.describe 'why/permalinks' do
  it 'renders the permalinks template' do
    render

    expect(view).to render_template('why/permalinks')
  end
end
