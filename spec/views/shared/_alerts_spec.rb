require 'rails_helper'

RSpec.describe 'shared/_alerts' do
  context 'with no alerts' do
    it 'renders the alerts template' do
      allow(view).to receive(:flash).and_return({})
      render

      expect(view).to render_template('shared/_alerts')
    end
  end

  context 'with alerts' do
    it 'renders the alerts template' do
      allow(view).to receive(:flash).and_return(alert: 'alert text', notice: 'notice text')
      render

      expect(view).to render_template('shared/_alerts')
    end
  end
end
