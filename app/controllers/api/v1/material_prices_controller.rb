module Api
  module V1
    class MaterialPricesController < ApplicationController

      def index
        materials = MaterialPrice.select("code","name","price","currency");
        render json: {status: 'SUCCESS', message: 'Price List', data: materials}, status: :ok
      end
      
       def show
        material = MaterialPrice.find_by(code: params[:id]);
        render json: {status: 'SUCCESS', message: 'Material properties', data: material}, status: :ok
      end
      
      def create
        material = MaterialPrice.new(material_price_params)

        if material.save
          render json: {status: 'SUCCESS', message: 'Material created', data: material}, status: :ok
        else
          render json: {status: 'ERROR', message: 'Error creating material', data: material.errors}, status: :unprocessable_entity
        end
      end 

      def update
        material = MaterialPrice.find_by(code: params[:id]);

        if material.update(material_update_price_params)
          render json: {status: 'SUCCESS', message: 'Material price updated', data: material}, status: :ok
        else
          render json: {status: 'ERROR', message: 'Error updating material', data: material.errors}, status: :unprocessable_entity
        end
      end
      
      private

      def material_price_params
        params.require(:material_price).permit(:cod, :name, :price, :price_cents, :currency)
      end

      def material_update_price_params
        params.require(:material_price).permit(:price, :price_cents)
      end
    end
  end
end 

