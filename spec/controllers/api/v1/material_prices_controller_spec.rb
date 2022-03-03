require 'rails_helper'

RSpec.describe Api::V1::MaterialPricesController, type: :controller do
  let!(:item)  { FactoryBot.create(:material_price) }
  let!(:item2) { FactoryBot.create(:material_price) }

  describe '#index' do
    context 'when resource is found' do
      before do
        get :index
      end

      it { expect(response).to have_http_status(:ok) }

      it 'shows the resource' do
        json = JSON.parse(response.body)

        expect(json['message']).to eq('Price List')
        expect(json['data'][0]['code']).to eq(item.code)
        expect(json['data'][0]['currency']).to eq('EUR')
        expect(json['data'][0]['price']).to eq(item.price.to_s)
        expect(json['data'][1]['code']).to eq(item2.code)
        expect(json['data'][1]['currency']).to eq('EUR')
        expect(json['data'][1]['price']).to eq(item2.price.to_s)
        expect(json['data'].length).to eq(2)
      end
    end
  end

  describe '#show' do
    context 'when resource is found' do
      before do
        get :show, params: { id: item.code }
      end

      it { expect(response).to have_http_status(:ok) }

      it 'shows the resource' do
        json = JSON.parse(response.body)

        expect(json['message']).to eq('Material properties')
        expect(json['data']['code']).to eq(item.code)
        expect(json['data']['currency']).to eq('EUR')
        expect(json['data']['price']).to eq(item.price.to_s)
      end
    end

    context 'when resource is not found' do
      before do
        get :show, params: { id: 'NOT-FOUND' }
      end

      it { expect(response).to have_http_status(:not_found) }
    end
  end

  describe '#create' do
    let(:new_item) { FactoryBot.build(:material_price) }
    subject(:the_request) do
      post :create, params: params
    end
    let(:params) {
      {
        material_price: JSON.parse(new_item.to_json)
      }
    }

    it 'creates one resource' do
      expect { the_request }.to change { MaterialPrice.count }.by(1)
    end

    context 'wrong parameters' do
      let(:params) {
        {
          material_price: {
            code: 'DEMO',
            name: 'DEMO',
            price: 'DEMO',
            price_cents: 'DEMO'
          }
        }
      }

      it 'fail to create the resource' do
        the_request

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe '#update' do
    let(:new_item) { FactoryBot.build(:material_price) }
    subject(:the_request) do
      patch :update, params: params
    end
    let(:price) { 10.0 }
    let(:params) {
      {
        id: item.code,
        material_price: {
          price: price
        }
      }
    }

    it 'update the resource' do
      the_request

      expect(response).to have_http_status(:ok)
    end

    context 'wrong parameters' do
      let(:price) { 'ONE' }

      it 'fail to update the resource' do
        the_request

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
