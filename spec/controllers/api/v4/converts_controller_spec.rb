require 'rails_helper'

describe Api::V4::ConvertsController do
  describe '#create' do
    context 'when passed a Llanfair file' do
      let(:file) do
        fixture_file_upload('llanfair')
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

        it 'renders a run schema' do
          expect(subject.body).to match_json_schema(:run)
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
        fixture_file_upload('malformed')
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
