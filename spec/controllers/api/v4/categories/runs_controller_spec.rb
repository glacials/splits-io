require 'rails_helper'

describe Api::V4::Categories::RunsController do
  describe '#index' do
    context 'for an existing category' do
      let(:category) { create(:category, :with_runs) }
      subject { get :index, params: {category: category.id} }

      it 'returns a 200' do
        expect(subject).to have_http_status 200
      end

      it 'renders a run array schema' do
        expect(subject.body).to match_json_schema(:category_runs)
      end
    end

    context 'for a nonexisting category' do
      subject { get :index, params: {category: '0'} }

      it 'returns a 404' do
        expect(subject).to have_http_status 404
      end
    end
  end
end
