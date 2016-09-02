require 'rails_helper'

describe Api::V4::CategoriesController do
  describe '#show' do
    context 'for an existing category' do
      let(:category) { create(:category) }
      subject { get :show, params: {category: category.id} }

      it 'returns a 200' do
        expect(subject).to have_http_status 200
      end

      it 'renders a category schema' do
        expect(subject.body).to match_json_schema(:category)
      end
    end
  end

  describe '#runners' do
  end

  describe '#runs' do
  end
end
