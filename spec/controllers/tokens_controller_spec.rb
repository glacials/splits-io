require 'rails_helper'

describe TokensController do
  describe '#create' do
    subject { post :create }

    context 'with no params' do
      it 'returns a 400' do
        expect(subject).to have_http_status :bad_request
      end
    end
  end
end
