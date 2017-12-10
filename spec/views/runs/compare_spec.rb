require 'rails_helper'

RSpec.describe 'runs/compare' do
  let(:user) { FactoryBot.create(:user) }

  context 'for a logged out user' do
    before { allow(view).to receive(:current_user).and_return(nil) }

    it 'renders the compare template for a logged out user' do
      assign(:run, FactoryBot.create(:run))
      assign(:comparison_run, FactoryBot.create(:run))
      render

      expect(view).to render_template('runs/compare')
    end
  end

  context 'for the logged in user\'s run' do
    before { allow(view).to receive(:current_user).and_return(user) }

    it 'renders the compare template for the user who needs improvement' do
      assign(:run, FactoryBot.create(:compare_subject_run, user: user))
      assign(:comparison_run, FactoryBot.create(:compare_object_run))
      render

      expect(view).to render_template('runs/compare')
    end
  end
end
