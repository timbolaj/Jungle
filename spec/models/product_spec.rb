require 'rails_helper'
    # :name, presence: true
    # :price, presence: true
    # :quantity, presence: true
    # :category, presence: true

RSpec.describe Product, :type => :model do
  describe 'Validations' do
    it "is valid with valid attributes of name, price, quantity and category" do
      @category = Category.new
      @category.id = 6
      @category.name = 'test'
      
      @product = Product.new
      @product.name = "prod"
      @product.price = 10000
      @product.quantity = 10000
      @product.category_id = @category

      @category.products = [@product]

      @product.save
      
      expect(@product).to be_valid
    end

    it "is not valid without a name" do
      @category = Category.new
      @category.id = 6
      @category.name = 'test'

      @product = Product.new
      @product.name = nil
      @product.price = 10000
      @product.quantity = 10000
      @product.category_id = @category
      @category.products = [@product]

      @product.save
      
      expect(@product.errors.full_messages.length).to eql(1)
      expect(@product.errors.full_messages[0]).to eql("Name can't be blank")
      expect(@product).to_not be_valid
    end

    it "is not valid without a price" do
      @category = Category.new
      @category.id = 6
      @category.name = 'test'

      @product = Product.new
      @product.name = 'test'
      @product.price = nil
      @product.quantity = 10000
      @product.category_id = @category
      @category.products = [@product]

      @product.save

      expect(@product.errors.full_messages.length).to eql(1)
      expect(@product.errors.full_messages[0]).to eql("Price is not a number")
      expect(@product).to_not be_valid

    end

    it "is not valid without a quantity" do
      @category = Category.new
      @category.id = 6
      @category.name = 'test'

      @product = Product.new
      @product.name = 'test'
      @product.price = 1
      @product.quantity = nil
      @product.category_id = @category
      @category.products = [@product]
      @product.save

      expect(@product.errors.full_messages.length).to eql(1)
      expect(@product.errors.full_messages[0]).to eql("Quantity can't be blank")
      expect(@product).to_not be_valid

    end

    it "is not valid without a category" do
      @category = Category.new
      @category.id = 6
      @category.name = 'test'

      @product = Product.new
      @product.name = 'test'
      @product.price = 1
      @product.quantity = 1
      @product.category_id = nil
      @product.save

      @category = [@product]

      expect(@product.errors.full_messages.length).to eql(1)
      expect(@product.errors.full_messages[0]).to eql("Category can't be blank")
      expect(@product).to_not be_valid

    end
  end
end