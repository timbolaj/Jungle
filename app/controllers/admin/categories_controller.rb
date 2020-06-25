class Admin::CategoriesController < ApplicationController
  
  http_basic_authenticate_with name: ENV["USERNAME"], password: ENV["PASSWORD"]

  def index
    @category_name_to_id = {}
    @product_per_category_count = {}
    @categories = Category.all
    @product_category = Category.joins(:products)

    @categories.each do |c|
      @product_per_category_count[c.name] = 0
      @category_name_to_id[c.name] = c.id
    end

    @product_category.map do |n|
      @product_per_category_count[n.name] += 1
    end
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to [:admin, :categories], notice: 'Product created!'
    else
      render :new
    end
  end

  private

  def category_params
    params.require(:category).permit(
      :name,
    )
  end
end
