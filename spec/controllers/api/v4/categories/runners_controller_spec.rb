require 'rails_helper'

describe Api::V4::Categories::RunnersController do
  describe '#index' do
    context 'for an exsiting category' do
      let(:category) { create(:category, :with_runners) }
      subject { get :index, params: {category: category.id} }

      it 'returns a 200' do
        expect(subject).to have_http_status 200
      end

      it 'renders a runner schema' do
        expect(subject.body).to match_json_schema(:category_runners)
      end

      it "doesn't render a runner more than once" do
        create(:run, :owned, category: category, user: Run.last.user)
        body = JSON.parse(subject.body)
        runner_ids = body["runners"].map { |runner| runner["id"] }
        expect(runner_ids.length).to eq runner_ids.uniq.length
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
