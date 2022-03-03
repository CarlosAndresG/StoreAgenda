include MoneyRails::ActionViewExtension
require 'memoist'
module Api
  module V1
    class InvoicesController < ApplicationController
      extend Memoist


      def index
        @ids_array = params[:id].split(',')
        @offers_array = []
        
        invoice_details = Hash.new           
        invoice_details["SubTotal"] = humanized_money_with_symbol(subtotal*100)
        invoice_details["Disccount"] = humanized_money_with_symbol(disccount_rules*100)
        invoice_details["Total"] = humanized_money_with_symbol((subtotal-disccount_rules)*100);

        if !@offers_array.nil?
          invoice_details["offers"] = @offers_array;
        end
        
        render json: {status: 'SUCCESS', message: 'Total Invoice calculated', data: invoice_details }, status: :ok
      end
      
       
      private

      def subtotal
        total = 0.00
        @ids_array.each do |id|
          a = MaterialPrice.find_by(code: id)
          if !a.nil?
            total = total + a.price_cents
          end
        end
        return total
      end
      memoize :subtotal

      def disccount_rules
         total_disccount = evaluate_rule1 + evaluate_rule2
      end
      memoize :disccount_rules

      def evaluate_rule1
        # 2-for-1 (buy two, one of them is free) for the `MUG` item;
        disccount = 0.00
        qty_mugs = @ids_array.tally["MUG"]

        if !qty_mugs.nil? and qty_mugs >= 2
          qty_discount = qty_mugs / 2
          disccount = MaterialPrice.find_by(code: "MUG").price_cents * qty_discount
          @offers_array.push("2-for-1 (buy two, one of them is free) for the `MUG` item")
        end

        return disccount
      end
      memoize :evaluate_rule1

      def evaluate_rule2
        # 30% discounts on all `TSHIRT` items when buying 3 or more.
        disccount = 0.00
        qty_tshirt = @ids_array.tally["TSHIRT"]

        if !qty_tshirt.nil? and qty_tshirt >= 3
          disccount = MaterialPrice.find_by(code: "TSHIRT").price_cents * qty_tshirt * 0.3
          @offers_array.push("30% discounts on all `TSHIRT` items when buying 3 or more")
        end

        return disccount
      end
      memoize :evaluate_rule2


      def material_price_params
        params.require(:material_price).permit(:cod, :name, :price, :price_cents, :currency)
      end

      def material_update_price_params
        params.require(:material_price).permit(:price, :price_cents)
      end
    end
  end
end 

