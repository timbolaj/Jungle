require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'After creation' do
    before :each do

      @category1 = Category.create name: 'test'
      @category2 = Category.create name: 'test2'
      @category3 = Category.create name: 'test3'

      # Setup at least two products with different quantities, names, etc
      @product1 = Product.create!(name: "prod", price: 1000, quantity: 1000)
      @category1.products = [@product1]

      @product2 = Product.create!(name: "prod2", price: 2, quantity: 2)
      @category2.products = [@product2]
      # Setup at least one product that will NOT be in the order
      @product3 = Product.create!(name: "prod3", price: 2, quantity: 2)
      @category3.products = [@product3]
    end
    # pending test 1
    xit 'deducts quantity from products based on their line item quantities' do
      # TODO: Implement based on hints below
      # 1. initialize order with necessary fields (see orders_controllers, schema and model definition for what is required)
      @order = Order.new(...)
      # 2. build line items on @order
      # ...
      # 3. save! the order - ie raise an exception if it fails (not expected)
      @order.save!
      # 4. reload products to have their updated quantities
      @product1.reload
      @product2.reload
      # 5. use RSpec expect syntax to assert their new quantity values
      # ...
    end
    # pending test 2
    xit 'does not deduct quantity from products that are not in the order' do
      # TODO: Implement based on hints in previous test
    end
  end
end
