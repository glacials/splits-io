require 'rails_helper'

RSpec.describe 'users/rivalries/_vs' do
  it 'renders vs' do
    render(partial: 'users/rivalries/vs', locals: {rivalry: FactoryGirl.create(:rivalry)})
  end
end
