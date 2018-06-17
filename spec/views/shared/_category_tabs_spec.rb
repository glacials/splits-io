require 'rails_helper'

RSpec.describe 'shared/_category_tabs' do
  let(:game) { FactoryBot.create(:game, :with_runs) }

  context 'with a normal link_type' do
    it 'renders the category tabs' do
      render(
        partial: 'shared/category_tabs',
        locals: {
          game: game,
          current_category: game.categories.first,
          link_type: :normal
        }
      )

      expect(view).to render_template('shared/_category_tabs')
    end
  end

  context 'with a SoB link_type' do
    it 'renders the category tabs' do
      render(
        partial: 'shared/category_tabs',
        locals: {
          game: game,
          current_category: game.categories.first,
          link_type: :sum_of_best
        }
      )

      expect(view).to render_template('shared/_category_tabs')
    end
  end
end
