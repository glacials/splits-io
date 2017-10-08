require 'rails_helper'

describe Api::V4::ConvertsController do
  describe '#create' do
    context 'when passed a Llanfair file' do
      let(:file) do
        fixture_file_upload('files/llanfair')
      end
      context 'with a good format' do
        subject { post :create, params: {file: file, format: 'json', historic: '1'} }
        let(:body) { JSON.parse(subject.body) }

        it 'returns a 200' do
          expect(subject).to have_http_status 200
        end

        it 'has no id field' do
          expect(body['run']['id']).to be_nil
        end

        it 'has a history field' do
          expect(body['run']['history']).to_not be_nil
        end

        it 'has the correct splits' do
          expect(body['run']['splits'].map { |s| [s['name'], s['duration']] }).to eq [
            ['Spiral Mountain', 211.23],
            ["Mumbo's Mountain", 808.199]
          ]
        end
      end

      context 'with a bad format' do
        subject { post :create, params: {file: file, format: 'llanfair'} }
        let(:body) { JSON.parse(subject.body) }

        it 'returns a 400' do
          expect(subject).to have_http_status 400
        end

        it 'returns an error body' do
          expect(body['status']).to be_truthy
          expect(body['message']).to be_truthy
        end
      end

      context 'with a missing parameter' do
        subject { post :create, params: {file: file} }
        let(:body) { JSON.parse(subject.body) }

        it 'returns a 400' do
          expect(subject).to have_http_status 400
        end

        it 'returns an error body' do
          expect(body['status']).to be_truthy
          expect(body['message']).to be_truthy
        end
      end
    end

    context 'with a malformed file' do
      let(:file) do
        fixture_file_upload('files/malformed')
      end
      subject { post :create, params: {file: file, format: 'json'} }
      let(:body) { JSON.parse(subject.body) }

      it 'returns a 400' do
        expect(subject).to have_http_status 400
      end

      it 'returns an error body' do
        expect(body['status']).to be_truthy
        expect(body['message']).to be_truthy
      end
    end
  end
end
