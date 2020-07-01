require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'After creation' do
    before :each do

      @category1 = Category.create! name: 'test'
      @category2 = Category.create! name: 'test2'
      @category3 = Category.create! name: 'test3'

      # Setup at least two products with different quantities, names, etc
      @product1 = Product.create!(name: "prod", price: 1000, quantity: 1000, category: @category1)
      @category1.products = [@product1]

      @product2 = Product.create!(name: "prod2", price: 2, quantity: 2, category: @category2)
      @category2.products = [@product2]
      # Setup at least one product that will NOT be in the order
      @product3 = Product.create!(name: "prod3", price: 2, quantity: 2, category: @category3)
      @category3.products = [@product3]
    end
    # pending test 1
    it 'deducts quantity from products based on their line item quantities' do
      # TODO: Implement based on hints below
      # 1. initialize order with necessary fields (see orders_controllers, schema and model definition for what is required)
      @order = Order.create(total_cents: 1000, stripe_charge_id: 2, email: 'bob@bob')
      @order.line_items.create!(product: @product1, quantity: 1, item_price: @product1.price, total_price: @product1.price * 1)
      @order.line_items.create!(product: @product2, quantity: 1, item_price: @product2.price, total_price: @product2.price * 1)
      # 3. save! the order - ie raise an exception if it fails (not expected)
      @order.save!
      puts @order
      # 4. reload products to have their updated quantities
      @product1.reload
      @product2.reload
      # 5. use RSpec expect syntax to assert their new quantity values
      expect(@product1.quantity).to eql(999)
      expect(@product2.quantity).to eql(1)
      # ...
    end
    # pending test 2
    it 'does not deduct quantity from products that are not in the order' do
      # TODO: Implement based on hints in previous test
      @order = Order.create(total_cents: 1000, stripe_charge_id: 2, email: 'bob@bob')
      @order.line_items.create(product: @product1, quantity: 1, item_price: @product1.price, total_price: @product1.price * 1)
      @order.line_items.create(product: @product2, quantity: 1, item_price: @product2.price, total_price: @product2.price * 1)
      # 3. save! the order - ie raise an exception if it fails (not expected)
      @order.save!
      # 4. reload products to have their updated quantities
      @product1.reload
      @product2.reload

      expect(@product3.quantity).to eql(2)
    end
  end
end
