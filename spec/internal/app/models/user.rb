# frozen_string_literal: true

class User < ApplicationRecord

  store :address, accessors: %i[city]

end
