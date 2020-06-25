class Admin::CategoriesController < ApplicationController
  #need to create an index, new and create actions
  def index
    @category_name_to_id = {}
    @product_per_category_count = {}
    @product_category = Category.joins(:products)

    @product_category.map do |n|
      unless @product_per_category_count[n.name] == nil
        @product_per_category_count[n.name] += 1
      else
        @product_per_category_count[n.name] = 1
        @category_name_to_id[n.name] = n.id
      end
    end
  end

  def new
  end

  def create
  end
end
