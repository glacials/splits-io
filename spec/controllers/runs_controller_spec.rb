require 'rails_helper'

describe RunsController do
  describe '#index' do
    let(:response) { get(:index) }

    it 'returns a 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe '#new' do
    let(:response) { get(:new) }

    it 'returns a 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe '#create' do
  end

  describe '#show' do
    let(:response) { get(:show, params: {run: id}) }

    context 'for a nonexisting run' do
      let(:id) { 'z' }

      it 'returns a 404' do
        expect(response).to have_http_status(404)
      end
    end

    context 'for an existing run' do
      let(:run) { FactoryBot.create(:run, :nicked) }

      context 'by id' do
        let(:id) { run.id36 }

        it 'returns a 200' do
          expect(response).to have_http_status(200)
        end

        it 'renders the template' do
          expect(response).to render_template('runs/show')
        end
      end

      context 'by nick' do
        let(:id) { run.nick }

        it 'returns a 302' do
          expect(response).to have_http_status(302)
        end

        it 'redirects to the modern URL' do
          expect(response).to redirect_to(run_path(run))
        end
      end
    end
  end

  describe '#edit' do
    let(:response) { get(:edit, params: {run: run.id36}) }

    context 'for an unowned run' do
      let(:run) { FactoryBot.create(:run, :unowned) }

      context 'by a logged-in user' do
        before { allow(controller).to receive(:current_user).and_return(FactoryBot.build(:user)) }

        it 'returns a 403' do
          expect(response).to have_http_status(403)
        end
      end

      context 'by a logged-out user' do
        before { allow(controller).to receive(:current_user).and_return(nil) }

        it 'returns a 403' do
          expect(response).to have_http_status(403)
        end
      end
    end

    context 'for an owned run' do
      let(:run) { FactoryBot.create(:run, :owned) }

      context "by a user who doesn't own the run" do
        context "because they're not logged in" do
          before { allow(controller).to receive(:current_user).and_return(nil) }

          it 'returns a 403' do
            expect(response).to have_http_status(403)
          end
        end

        context "because they're a different user" do
          before { allow(controller).to receive(:current_user).and_return(FactoryBot.build(:user)) }

          it 'returns a 403' do
            expect(response).to have_http_status(403)
          end
        end
      end

      context 'by the user who owns the run' do
        before { allow(controller).to receive(:current_user).and_return(run.user) }

        it 'returns a 200' do
          expect(response).to have_http_status(200)
        end
      end
    end
  end

  describe '#update' do
    context 'category' do
      let(:response) do
        put(
          :update, params: {
            'run' => run.id36,
            "#{run.id36}[category]" => FactoryBot.create(:category).id
          }
        )
      end

      context 'for an unowned run' do
        let(:run) { FactoryBot.create(:run, :unowned) }

        context 'by a logged-in user' do
          before { allow(controller).to receive(:current_user).and_return(FactoryBot.build(:user)) }

          it 'returns a 403' do
            expect(response).to have_http_status(403)
          end
        end

        context 'by a logged-out user' do
          before { allow(controller).to receive(:current_user).and_return(nil) }

          it 'returns a 403' do
            expect(response).to have_http_status(403)
          end
        end
      end

      context 'for an owned run' do
        let(:run) { FactoryBot.create(:run, :owned) }

        context "by a user who doesn't own the run" do
          context "because they're not logged in" do
            before { allow(controller).to receive(:current_user).and_return(nil) }

            it 'returns a 403' do
              expect(response).to have_http_status(403)
            end
          end

          context "because they're a different user" do
            before { allow(controller).to receive(:current_user).and_return(FactoryBot.build(:user)) }

            it 'returns a 403' do
              expect(response).to have_http_status(403)
            end
          end
        end

        context 'by the user who owns the run' do
          before { allow(controller).to receive(:current_user).and_return(run.user) }

          it 'returns a 302' do
            expect(response).to have_http_status(302)
          end

          it 'redirects to the run edit page' do
            expect(response).to redirect_to(edit_run_path(run))
          end
        end
      end
    end
  end

  describe '#destroy' do
    let(:response) { delete(:destroy, params: {run: run.id36}) }

    context 'for an unowned run' do
      let(:run) { FactoryBot.create(:run, :unowned) }

      context 'by a logged-in user' do
        before { allow(controller).to receive(:current_user).and_return(FactoryBot.build(:user)) }

        it 'returns a 403' do
          expect(response).to have_http_status(403)
        end
      end

      context 'by a logged-out user' do
        before { allow(controller).to receive(:current_user).and_return(nil) }

        it 'returns a 403' do
          expect(response).to have_http_status(403)
        end
      end
    end

    context 'for an owned run' do
      let(:run) { FactoryBot.create(:run, :owned) }

      context "by a user who doesn't own the run" do
        context "because they're not logged in" do
          before { allow(controller).to receive(:current_user).and_return(nil) }

          it 'returns a 403' do
            expect(response).to have_http_status(403)
          end
        end

        context "because they're a different user" do
          before { allow(controller).to receive(:current_user).and_return(FactoryBot.build(:user)) }

          it 'returns a 403' do
            expect(response).to have_http_status(403)
          end
        end
      end

      context 'by the user who owns the run' do
        before { allow(controller).to receive(:current_user).and_return(run.user) }

        it 'returns a 302' do
          expect(response).to have_http_status(302)
        end

        it 'redirects to the frontpage' do
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end

  describe '#compare' do
    let(:run) { FactoryBot.create(:run, :parsed) }
    let(:comparison_run) { FactoryBot.create(:run, :parsed) }

    let(:response) { get(:compare, params: {run: run.id36, comparison_run: comparison_run.id36}) }

    context 'by a logged-in user' do
      before { allow(controller).to receive(:current_user).and_return(FactoryBot.build(:user)) }

      it 'returns a 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe '#download' do
    let(:run) { FactoryBot.create(:run, :parsed) }
    let(:response) { get(:download, params: {run: run.id36, timer: timer}) }

    context 'as Urn' do
      let(:timer) { 'urn' }

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

    context 'as WSplit' do
      let(:timer) { 'wsplit' }

      it 'returns a 200' do
        expect(response).to have_http_status(200)
      end
    end
  end
end
