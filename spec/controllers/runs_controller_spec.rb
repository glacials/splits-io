require 'rails_helper'

describe RunsController do
  before { allow(Twitch::Videos).to receive(:recent).and_return([]) }

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
      let(:id) { 'an impossible run id' }

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
    context 'for an unowned run without permissions' do
      let(:run) { FactoryBot.create(:run, :unowned) }
      let(:response) do
        put(
          :update, params: {
            'run' => run.id36,
            "#{run.id36}[category]" => FactoryBot.create(:category).id
          }
        )
      end

      context 'for a logged-out user' do
        before { allow(controller).to receive(:current_user).and_return(nil) }

        it 'returns a 403' do
          expect(response).to have_http_status(403)
        end
      end

      context 'for a logged-in user' do
        before { allow(controller).to receive(:current_user).and_return(FactoryBot.build(:user)) }

        it 'returns a 403' do
          expect(response).to have_http_status(403)
        end
      end
    end

    context 'for an owned run without permissions' do
      let(:run) { FactoryBot.create(:run, :owned) }
      let(:response) do
        put(
          :update, params: {
            'run' => run.id36,
            "#{run.id36}[category]" => FactoryBot.create(:category).id
          }
        )
      end

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
    end

    context 'changing categories by the owner' do
      let(:run) { FactoryBot.create(:run, :owned) }
      let(:category) { FactoryBot.create(:category) }
      let(:response) do
        put(
          :update, params: {
            'run' => run.id36,
            "#{run.id36}[category]" => category.id
          }
        )
      end
      before { allow(controller).to receive(:current_user).and_return(run.user) }
      before { allow(Twitch::Videos).to receive(:recent).and_return([]) }

      it 'returns a 302' do
        expect(response).to have_http_status(302)
      end

      it 'redirects to the run edit page' do
        expect(response).to redirect_to(edit_run_path(run))
      end

      it 'has the new category id' do
        response
        expect(run.reload.category).to eq(category)
      end
    end

    context 'disowning the run by the owner' do
      let(:run) { FactoryBot.create(:run, :owned) }
      let(:response) do
        put(
          :update, params: {
            'run' => run.id36,
            "#{run.id36}[disown]" => true
          }
        )
      end
      before { allow(controller).to receive(:current_user).and_return(run.user) }
      before { allow(Twitch::Videos).to receive(:recent).and_return([]) }

      it 'returns a 302' do
        expect(response).to have_http_status(302)
      end

      it 'redirects to the run edit page' do
        expect(response).to redirect_to(run_path(run))
      end

      it 'has no owner' do
        response
        expect(run.reload.user).to be_nil
      end
    end

    context 'changing srdc urls by the owner' do
      let(:run) { FactoryBot.create(:run, :owned) }
      let(:response) do
        put(
          :update, params: {
            'run' => run.id36,
            "#{run.id36}[srdc_url]" => 'https://www.speedrun.com/tfoc/run/6yjoqgzd'
          }
        )
      end
      before { allow(controller).to receive(:current_user).and_return(run.user) }
      before { allow(Twitch::Videos).to receive(:recent).and_return([]) }

      it 'returns a 302' do
        expect(response).to have_http_status(302)
      end

      it 'redirects to the run edit page' do
        expect(response).to redirect_to(edit_run_path(run))
      end

      it 'has the new srdc id' do
        response
        expect(run.reload.srdc_id).to eq('6yjoqgzd')
      end
    end

    context 'changing video urls by the owner' do
      let(:run) { FactoryBot.create(:run, :owned) }
      before { allow(controller).to receive(:current_user).and_return(run.user) }
      before { allow(Twitch::Videos).to receive(:recent).and_return([]) }

      context 'adding a new url' do
        let(:response) do
          put(
            :update, params: {
              'run' => run.id36,
              "#{run.id36}[video_url]" => 'http://www.twitch.tv/glacials/c/3463112'
            }
          )
        end

        it 'returns a 302' do
          expect(response).to have_http_status(302)
        end

        it 'redirects to the run edit page' do
          expect(response).to redirect_to(edit_run_path(run))
        end

        it 'has the new video url' do
          response
          expect(run.reload.video.url).to eq('http://www.twitch.tv/glacials/c/3463112')
        end
      end

      context 'removing the video' do
        let(:response) do
          put(
            :update, params: {
              'run' => run.id36,
              "#{run.id36}[video_url]" => ''
            }
          )
        end

        it 'returns a 302' do
          expect(response).to have_http_status(302)
        end

        it 'redirects to the run edit page' do
          expect(response).to redirect_to(edit_run_path(run))
        end

        it 'has the new video url' do
          FactoryBot.create(:video, videoable: run)
          response
          expect(run.reload.video).to be_nil
        end
      end
    end

    context 'archiving by the owner' do
      before { allow(controller).to receive(:current_user).and_return(run.user) }
      before { allow(Twitch::Videos).to receive(:recent).and_return([]) }

      context 'from unarchived to archived' do
        let(:run) { FactoryBot.create(:run, :owned) }
        let(:response) do
          put(
            :update, params: {
              'run' => run.id36,
              "#{run.id36}[archived]" => true
            }
          )
        end

        it 'returns a 302' do
          expect(response).to have_http_status(302)
        end

        it 'redirects to the run edit page' do
          expect(response).to redirect_to(edit_run_path(run))
        end

        it 'has been archived' do
          response
          expect(run.reload.archived).to eq(true)
        end
      end

      context 'from archived to unarchived' do
        let(:run) { FactoryBot.create(:run, :owned, :archived) }
        let(:response) do
          put(
            :update, params: {
              'run' => run.id36,
              "#{run.id36}[archived]" => false
            }
          )
        end
        it 'returns a 302' do
          expect(response).to have_http_status(302)
        end

        it 'redirects to the run edit page' do
          expect(response).to redirect_to(edit_run_path(run))
        end

        it 'has been unarchived' do
          response
          expect(run.reload.archived).to eq(false)
        end
      end
    end

    context 'changing the default timing' do
      before { allow(controller).to receive(:current_user).and_return(run.user) }
      before { allow(Twitch::Videos).to receive(:recent).and_return([]) }

      context 'to gametime' do
        let(:run) { FactoryBot.create(:run, :owned) }
        let(:response) do
          put(
            :update, params: {
              'run' => run.id36,
              "#{run.id36}[default_timing]" => 'game'
            }
          )
        end

        it 'returns a 302' do
          expect(response).to have_http_status(302)
        end

        it 'redirects to the run edit page' do
          expect(response).to redirect_to(edit_run_path(run))
        end

        it 'has the new timing' do
          response
          expect(run.reload.default_timing).to eq('game')
        end
      end

      context 'to realtime' do
        let(:run) { FactoryBot.create(:run, :owned, default_timing: Run::GAME) }
        let(:response) do
          put(
            :update, params: {
              'run' => run.id36,
              "#{run.id36}[default_timing]" => 'real'
            }
          )
        end

        it 'returns a 302' do
          expect(response).to have_http_status(302)
        end

        it 'redirects to the run edit page' do
          expect(response).to redirect_to(edit_run_path(run))
        end

        it 'has the new timing' do
          response
          expect(run.reload.default_timing).to eq('real')
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
end
