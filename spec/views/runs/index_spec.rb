require 'rails_helper'

RSpec.describe 'runs/index' do
  context 'while logged out' do
    before { allow(view).to receive(:current_user).and_return(nil) }

    it 'renders the index template' do
      assign(:run, FactoryBot.create(:livesplit16_run, :parsed))
      render

      expect(view).to render_template('runs/index')
    end
  end

  context 'while logged in' do
    before { allow(view).to receive(:current_user).and_return(FactoryBot.build(:user)) }

    it 'renders the index template' do
      assign(:example_run, FactoryBot.create(:livesplit16_run, :parsed))
      assign(:example_segment, FactoryBot.create(:segment))
      render

      expect(view).to render_template('runs/index')
    end
  end
end
