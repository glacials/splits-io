require 'rails_helper'

RSpec.describe 'shared/_rollbarjs' do
  it 'renders the rollbar template' do
    render

    expect(view).to render_template('shared/_rollbarjs')
  end
end
