class MaterialPrice < ActiveRecord::Base
  monetize :price, as: :price_cents
  scope :material_price, ->(code) { where(code: code) }
end