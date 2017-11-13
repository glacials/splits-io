require 'rails_helper'

RSpec.describe 'rivalries/_vs' do
  it 'renders vs' do
    render(partial: 'rivalries/vs', locals: {rivalry: FactoryBot.create(:rivalry)})
  end
end
