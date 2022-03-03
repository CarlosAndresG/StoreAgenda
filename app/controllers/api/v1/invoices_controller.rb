module Api
  module V1
    class InvoicesController < ApplicationController
      extend Memoist

      before_action :material_price, only: %i[index]

      def index
        @offers_array = []

        invoice_details = ActiveSupport::HashWithIndifferentAccess.new
        invoice_details[:SubTotal] = humanized_money_with_symbol(subtotal)
        invoice_details[:Disccount] = humanized_money_with_symbol(disccount_rules * 100)
        invoice_details[:Total] = humanized_money_with_symbol((subtotal - disccount_rules))

        invoice_details[:offers] = @offers_array unless @offers_array.empty?

        render json: { message: 'Total Invoice calculated', data: invoice_details }, status: :ok
      end

      private

      def subtotal
        total = 0.0

        material_price.pluck(:code, :price).each do |code, price|
          total += material_params[code] * price
        end
        total.to_money
      end
      memoize :subtotal

      def disccount_rules
        (evaluate_rule1 + evaluate_rule2).to_money
      end
      memoize :disccount_rules

      def evaluate_rule1
        # 2-for-1 (buy two, one of them is free) for the `MUG` item;
        disccount = 0.00
        qty_mugs = material_params['MUG']

        if qty_mugs && qty_mugs >= 2
          qty_discount = qty_mugs / 2
          disccount = material_price.find_by(code: 'MUG').price_cents * qty_discount
          @offers_array.push('2-for-1 (buy two, one of them is free) for the `MUG` item')
        end

        disccount
      end
      memoize :evaluate_rule1

      def evaluate_rule2
        # 30% discounts on all `TSHIRT` items when buying 3 or more.
        disccount = 0.00
        qty_tshirt = material_params['TSHIRT']

        if qty_tshirt && qty_tshirt >= 3
          disccount = material_price.find_by(code: 'TSHIRT').price_cents * qty_tshirt * 0.3
          @offers_array.push('30% discounts on all `TSHIRT` items when buying 3 or more')
        end

        disccount
      end
      memoize :evaluate_rule2

      def material_price_params
        params.require(:material_price).permit(:cod, :name, :price, :price_cents, :currency)
      end

      def material_update_price_params
        params.require(:material_price).permit(:price, :price_cents)
      end

      def material_price
        MaterialPrice.material_price(material_params.keys)
      end

      def material_params
        params[:id].split(',').map(&:strip).tally
      end
      memoize :material_params

      def humanized_money_with_symbol(args)
        ActionController::Base.helpers.humanized_money_with_symbol(args)
      end
    end
  end
end