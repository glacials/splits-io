require 'rails_helper'

describe Api::V3::RunsController do
  describe '#show' do
    let(:game) do
      instance_double(
        "Game",
        name: "Tron: Evolution",
        read_attribute_for_serialization: self,
      )
    end
    let(:category) do
      instance_double(
        "Category",
        game: game,
        name: "Any% NG+",
        read_attribute_for_serialization: self,
      )
    end
    let(:run) do
      instance_double(
        "Run",
        id: 10,
        id36: 'a',
        path: '/a',
        game: game,
        category: category,
        to_s: "Tron: Evolution Any% NG+",
        image_url: nil,
        sum_of_best: 2,
        splits: [
          instance_double("Split", 'best' => 3, 'best=' => true)
        ],
        read_attribute_for_serialization: self,
      )
      create(:run)
    end

    context 'when given a valid id' do
      subject(:response) { get :show, params: {id: run.id36} }
      subject(:body) { JSON.parse(response.body)['run'] }

      it '200s' do
        expect(response).to have_http_status(200)
      end

      it 'returns a run with the correct id' do
        expect(body['id']).to eq(run.id)
      end
    end

    context 'when given a bad id' do
      subject(:response) { get :show, params: {id: '...'} }
      subject(:body) { JSON.parse(response.body) }

      it '404s' do
        expect(response).to have_http_status(404)
      end

      it 'returns an error body' do
        expect(body['status']).to be_truthy
        expect(body['message']).to be_truthy
      end
    end
  end

  describe '#create' do
    let(:run) do
      create(:run)
    end

    context 'when given no OAuth token' do
      subject(:response) { post :create, params: {file: run.file} }

      it '201s' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when given an invalid OAuth token' do
      subject(:response) { post :create, params: {file: run.file} }

      it '401s' do
        request.headers['Authorization'] = 'Bearer bad_token'

        expect(response).to have_http_status(401)
      end
    end

    context 'when given a valid OAuth token with no scopes' do
      subject(:response) { post :create, params: {file: run.file} }

      it '403s' do
        application = Doorkeeper::Application.create(
          name: 'Test Application',
          redirect_uri: 'http://localhost:3000/',
          owner: create(:user)
        )
        authorization = Doorkeeper::AccessToken.create(application_id: application.id, resource_owner_id: create(:user))
        auth_header = "Bearer #{authorization.token}"
        request.headers['Authorization'] = auth_header

        expect(response).to have_http_status(403)
      end
    end

    context 'when given a valid OAuth token with an upload_run scope' do
      subject(:response) { post :create, params: {file: run.file} }

      it '201s' do
        application = Doorkeeper::Application.create(
          name: 'Test Application',
          redirect_uri: 'http://localhost:3000/',
          owner: create(:user)
        )
        authorization = Doorkeeper::AccessToken.create(
          application_id: application.id,
          resource_owner_id: create(:user),
          scopes: 'upload_run'
        )
        auth_header = "Bearer #{authorization.token}"
        request.headers['Authorization'] = auth_header

        expect(response).to have_http_status(201)
      end
    end
  end
end
