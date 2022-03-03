module Api
  module V1
    class MaterialPricesController < ApplicationController
      before_action :set_material_price, only: %i[show update]

      def index
        materials = MaterialPrice.select(:code, :name, :price, :currency)
        render json: { message: 'Price List', data: materials }, status: :ok
      end

      def show
        render json: { message: 'Material properties', data: @material_price }, status: :ok
      end

      def create
        material = MaterialPrice.new(material_price_params)

        if material.save
          render json: { message: 'Material created', data: material }, status: :ok
        else
          render json: { message: 'Error creating material', data: material.errors }, status: :unprocessable_entity
        end
      end

      def update
        @material_price.assign_attributes(material_update_price_params)

        if @material_price.save
          render json: { message: 'Material price updated', data: @material_price }, status: :ok
        else
          render json: { message: 'Error updating material', data: @material_price.errors }, status: :unprocessable_entity
        end
      end

      private

      def material_price_params
        params.require(:material_price).permit(:cod, :name, :price, :price_cents, :currency)
      end

      def material_update_price_params
        params.require(:material_price).permit(:price, :price_cents)
      end

      def set_material_price
        @material_price = MaterialPrice.find_by!(code: params[:id])
      end
    end
  end
end
