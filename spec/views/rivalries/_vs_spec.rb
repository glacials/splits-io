require 'rails_helper'

RSpec.describe 'rivalries/_vs' do
  it 'renders vs' do
    render(partial: 'rivalries/vs', locals: {rivalry: FactoryGirl.create(:rivalry)})
  end
end
