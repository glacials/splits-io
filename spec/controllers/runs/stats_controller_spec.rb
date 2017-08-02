require 'rails_helper'

describe Runs::StatsController do
  describe '#index' do
    let(:response) { get(:index, params: {run: create(:run)}) }

    it 'returns a 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe '#run_history_csv' do
    let(:response) { get(:run_history_csv, params: {run: create(:run)}) }

    it 'returns a 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe '#segment_history_csv' do
    let(:response) { get(:segment_history_csv, params: {run: create(:run)}) }

    it 'returns a 200' do
      expect(response).to have_http_status(200)
    end
  end
end
