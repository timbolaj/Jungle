class OrdersController < ApplicationController

  def show
    @order = Order.find(params[:id])
    @line_items = @order.line_items
  end

  def create
    charge = perform_stripe_charge
    order  = create_order(charge)

    if order.valid?
      # OrderMailer.send(order)      
      empty_cart!
      redirect_to order, notice: 'Your Order has been placed.'
    else
      redirect_to cart_path, flash: { error: order.errors.full_messages.first }
    end

  rescue Stripe::CardError => e
    redirect_to cart_path, flash: { error: e.message }
  end

  private

  def empty_cart!
    # empty hash means no products in cart :)
    update_cart({})
  end

  def perform_stripe_charge
    Stripe::Charge.create(
      source:      params[:stripeToken],
      amount:      (cart_subtotal_cents * 100).to_int,
      description: "Khurram Virani's Jungle Order",
      currency:    'cad'
    )
  end

  def create_order(stripe_charge)

    order = Order.new(
      email: params[:stripeEmail],
      total_cents: cart_subtotal_cents * 100,
      stripe_charge_id: stripe_charge.id, # returned by stripe
    )

    enhanced_cart.each do |entry|
      product = entry[:product]
      quantity = entry[:quantity]
      order.line_items.new(
        product: product,
        quantity: quantity,
        item_price: product.price,
        total_price: product.price * quantity
      )
    end

    order.save!
    order
  end

  def list_order_items order
    #@line_items is an array
    # need to loop over it and assign the relevant fields
    # @img, @name, @description, @quantity, @line_total
    order.map {|item| { name: item.name, quantity: item.quantity, description: item.description }}
    # Product.where(id: cart.keys).map {|product| { product:product, quantity: cart[product.id.to_s] }
  end
end
