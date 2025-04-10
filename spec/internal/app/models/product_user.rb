# frozen_string_literal: true

class ProductUser < ApplicationRecord

  self.primary_key = %i[product_id user_id]

end
