require 'rails_helper'

describe Users::RivalriesController do
  describe '#index' do
    user = FactoryGirl.create(:user, :with_runs)
    user.categories.each do |category|
      FactoryGirl.create(:run, :parsed, category: category, user: FactoryGirl.create(:user))
      FactoryGirl.create(:run, :attempteless, category: category, user: FactoryGirl.create(:user))
    end

    let(:response) { get(:index, params: {user: user}) }

    it 'returns a 200' do
      expect(response).to have_http_status(200)
    end
  end
end
