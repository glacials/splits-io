require 'rails_helper'

describe Api::V4::RunsController do
  let(:run) { FactoryGirl.create(:run) }
  
  it 'should return the run' do
    get :show, id: run.id
    expect(response).to have_http_status(200)
  end
end
