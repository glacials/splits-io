require 'rails_helper'

RSpec.describe 'table_locals' do
  class RunsHelperTester
    include RunsHelper

    def current_user
    end

    def params
    end
  end

  it 'returns the right information for "my PBs" table' do
    tester = RunsHelperTester.new

    user = FactoryBot.create(:user)
    allow(tester).to receive(:current_user) { user }
    allow(tester).to receive(:params) { {} }

    result = tester.table_locals(:my_pbs)

    expect(result[:type]).to eq(:current_user)
    expect(result[:source]).to eq(user)
    expect(result[:runs]).to eq(user.pbs)
    expect(result[:cols]).to eq(%i[time name uploaded owner_controls rival])
    expect(result[:description]).to eq('My Personal Bests')
  end
end
