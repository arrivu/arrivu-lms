class PaymentsController < ApplicationController
  include ELearningHelper

  before_filter :require_user
  before_filter :set_e_learning
  before_filter :check_private_e_learning
  before_filter :check_e_learning
  rescue_from Paypal::Exception::APIError, with: :paypal_api_error

  def show
    @payment = Payment.find_by_identifier! params[:id]
  end

  def create
    payment = Payment.create! params[:payment]
    payment.setup!(
        success_payments_url,
        cancel_payments_url,
    )
    if payment.popup?
      redirect_to payment.popup_uri
    else
      redirect_to payment.redirect_uri
    end
  end

  def destroy
    Payment.find_by_identifier!(params[:id]).unsubscribe!
    redirect_to root_path, notice: 'Recurring Profile Canceled'
  end

  def success
    handle_callback do |payment|
      payment.complete!(params[:PayerID])
      flash[:notice] = 'Payment Transaction Completed'
      #payment_url(payment.identifier)
      redirect_to library_payment_complete_path(payment.course,payment_id: payment.id)
      return
    end
  end

  def cancel
    handle_callback do |payment|
      payment.cancel!
      flash[:info] = 'Payment Request Canceled'
      redirect_to root_path
    end
  end

  private

  def handle_callback
    payment = Payment.find_by_token! params[:token]
    @redirect_uri = yield payment
    if payment.popup?
      render :close_flow, layout: false
    end
  end

  def paypal_api_error(e)
    redirect_to root_url, error: e.response.details.collect(&:long_message).join('<br />')
  end

end
