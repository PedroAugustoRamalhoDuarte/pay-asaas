class AddOrderIdToPayCharges < ActiveRecord::Migration[8.0]
  def change
    add_reference :pay_charges, :order, null: false, foreign_key: true
  end
end
