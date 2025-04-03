module ChargeExtensions
  extend ActiveSupport::Concern

  included do
    belongs_to :order
    after_create :fulfill_order
  end

  def fulfill_order
    order.fulfill!
  end
end
