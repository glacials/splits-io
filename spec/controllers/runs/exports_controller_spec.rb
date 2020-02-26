require 'rails_helper'

describe Runs::ExportsController do
  describe '#run_history_csv' do
    let(:response) { get(:history_csv, params: {run: create(:run)}) }

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

  describe '#timer' do
    let(:run) { FactoryBot.create(:run, :parsed) }
    let(:response) { get(:timer, params: {run: run.id36, timer: timer}) }

    context 'as the Splits.io Exchange Format' do
      let(:timer) { 'exchange' }

      it 'returns a 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'as LiveSplit' do
      let(:timer) { 'livesplit' }

      it 'returns a 302' do
        expect(response).to have_http_status(302)
      end
    end

    context 'as SplitterZ' do
      let(:timer) { 'splitterz' }

      it 'returns a 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'as Time Split Tracker' do
      let(:timer) { 'splitterz' }

      it 'returns a 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'as Urn' do
      let(:timer) { 'urn' }

      it 'returns a 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'as WSplit' do
      let(:timer) { 'wsplit' }

      it 'returns a 200' do
        expect(response).to have_http_status(200)
      end
    end
  end
end
