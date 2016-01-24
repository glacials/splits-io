require 'rails_helper'

describe Api::V4::ConvertsController do

  describe '#create' do
    context 'from Llanfair' do
      context 'supported format'
        let(:file) do
          fixture_file_upload('files/llanfair')
        end
        subject { post :create, params: {file: file, format: "json", historic: "on"} }
        let(:body) { JSON.parse(subject.body) }

        it "returns a 200" do
          expect(subject).to have_http_status 200
        end

        it "doesn't include id" do
          expect(body['id']).to be_nil
        end

        it "has the correct splits" do
          expect(body["splits"].map { |s| [s["name"], s["duration"]] }).to eq([
            ["Spiral Mountain", 211.23],
            ["Mumbo's Mountain", 808.2]
          ])
        end
      end

    context 'unsupported format' do
      let(:file) do
        fixture_file_upload('files/llanfair')
      end
      subject { post :create, params: {file: file, format: "llanfair" } }

      it "returns a 400" do
        expect(subject).to have_http_status 400
      end
    end
  end

end
