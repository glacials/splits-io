require 'rails_helper'

describe Users::RivalriesController do
  describe '#index' do

    context 'when logged in' do
      user = FactoryGirl.create(:user, :with_runs)
      user.categories.each do |category|
        FactoryGirl.create(:run, :parsed, category: category, user: FactoryGirl.create(:user))
        FactoryGirl.create(:run, :attemptless, category: category, user: FactoryGirl.create(:user))
      end

      before { allow(controller).to receive(:current_user).and_return(user) }

      let(:response) { get(:index) }

      it 'returns a 200' do
        expect(response).to have_http_status(200)
      end
    end
    context 'when logged in' do
      before { allow(controller).to receive(:current_user).and_return(nil) }

      let(:response) { get(:index) }

      it 'returns a 302' do
        expect(response).to have_http_status(302)
      end
    end
  end
end
