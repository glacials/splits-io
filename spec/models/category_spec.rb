require 'rails_helper'

describe Category, type: :model do
  let(:category) { FactoryGirl.create(:category) }

  context 'when merged' do
    let(:parent_category) { FactoryGirl.create(:category) }
    let(:category_runs) { category.runs }
    let(:parent_category_runs) { parent_category.runs }

    before do
      category.merge_into!(parent_category)
    end

    it 'destroys itself' do
      expect(category.destroyed?).to eq(true)
    end

    it 'has no runs left' do
      expect(category.runs.count).to eq(0)
    end

    it 'gives the other category its runs' do
      expect(parent_category.runs).to include(*category_runs)
    end

    it "doesn't touch the other category's runs" do
      expect(parent_category.runs).to include(*parent_category_runs)
    end

    it "doesn't migrate any unrelated runs" do
      expect(parent_category.runs.count).to eq(category_runs.count + parent_category_runs.count)
    end
  end
end
