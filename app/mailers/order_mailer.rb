class OrderMailer < ApplicationMailer
  default from: 'jungle@jungle.com'

  def send_email order
    @order = order
    mail(to: @order.email, subject: "Order id: #{@order.id}. Thank you for shopping with us!")
  end
end
