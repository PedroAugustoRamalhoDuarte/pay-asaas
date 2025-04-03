class Order < ApplicationRecord
  def fulfill!
    update!(name: "fulfilled")
  end
end
