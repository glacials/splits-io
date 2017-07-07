require 'rails_helper'

describe ApplicationsController do
  describe '#create' do
    let(:name) { 'beepy' } # Just name it anything unique so we can check if it exists later
    let(:user) { build(:user) }
    subject(:response) do
      post :create, params: {doorkeeper_application: {name: name, redirect_uri: redirect_uri}}
    end

    context 'when logged in' do
      before { allow(controller).to receive(:current_user) { user } }

      context 'when given a valid redirect_uri' do
        let(:redirect_uri) { 'https://localhost' }

        it 'redirects back' do
          expect(response).to redirect_to(settings_path)
        end
     end

     context 'when given a non-HTTPS redirect URI' do
       let(:redirect_uri) { 'http://localhost' }

       it 'does not create the application' do
         expect(Doorkeeper::Application.find_by(name: name)).to be_nil
       end
     end
   end

   context 'when not logged in' do
     it 'does not create an application' do
       expect(Doorkeeper::Application.find_by(name: name)).to be_nil
     end
   end
 end

 describe '#destroy' do
   let(:application) { create(:application) }
   let(:response) { delete :destroy, params: {application: application.id} }

   context 'when logged in as the owner' do
     before { allow(controller).to receive(:current_user) { application.owner } }

     it 'redirects back' do
       expect(response).to redirect_to(settings_path)
     end
   end

   context 'when logged in not as the owner' do
     before { allow(controller).to receive(:current_user) { build(:user) } }

     it 'returns a 403' do
       expect(response).to have_http_status(403)
     end
   end

   context 'when not logged in' do
     before { allow(controller).to receive(:current_user) { nil } }

     it 'returns a 403' do
       expect(response).to have_http_status(403)
     end
   end
 end
end
