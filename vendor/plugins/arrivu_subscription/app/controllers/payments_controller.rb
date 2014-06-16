class PaymentsController < ApplicationController
  before_filter :require_context
  require 'constants'
  require 'pz_utils.rb'
  require 'config.rb'
  require 'charging/charging_response.rb'
  include SubscriptionPlansHelper
  include PZ_Utils
  include ChargingResponse


  def payment_confirm
    if authorized_action(@account, @current_user, [:manage_account_settings, :manage_storage_quotas])
      @subscription = Subscription.find(params[:subscription_id])
      @subscription_plan = SubscriptionPlan.find(params[:subscription_plan_id])
      @grouped_payments = [[Payment.new]]
      unless params[:billing].empty?
        @selected_billing = BillingType.find(params[:billing])
        unless @selected_billing.nil?
          tmp_val = Money.new(@subscription_plan.rate_cents.to_i, "INR") * @selected_billing.discount_percentage
          discount = (tmp_val/100) * @selected_billing.months
          actual_amount = Money.new(@subscription_plan.rate_cents.to_i, "INR") * @selected_billing.months
          @final_amount = actual_amount - discount
        end
      end
    end
  end


  def show
    @payment = Payment.find_by_merchant_transaction_id params[:merchant_transaction_id]
  end

  def create
    payment = Payment.create! params[:payment]

    @charging_api_url = get_charging_api_url
    @params = {
        :merchant_id => PZ_Config::MERCHANT_ID,
        :merchant_transaction_id => payment.merchant_transaction_id,
        :merchant_key_id => PZ_Config::MERCHANT_KEY_ID,
        :buyer_email_address => payment.buyer_email_address,
        :transaction_type => payment.transaction_type,
        :transaction_amount => payment.transaction_amount.to_i,
        :payment_method => payment.payment_method,
        :currency => payment.currency,
        :ui_mode => payment.ui_mode,
        :hash_method => payment.hash_method,
        :bank_name => payment.bank_name,
        :hash => generate_hash({
                                   :merchant_id => PZ_Config::MERCHANT_ID,
                                   :merchant_transaction_id => payment.merchant_transaction_id,
                                   :merchant_key_id => PZ_Config::MERCHANT_KEY_ID,
                                   :buyer_email_address => payment.buyer_email_address,
                                   :transaction_type => payment.transaction_type,
                                   :transaction_amount => payment.transaction_amount.to_i,
                                   :payment_method => payment.payment_method,
                                   :currency => payment.currency,
                                   :ui_mode => payment.ui_mode,
                                   :hash_method => payment.hash_method,
                                   :bank_name => payment.bank_name,
                                   :callback_url => "#{HostUrl.context_host(@domain_root_account)}/accounts/#{@account.id}/payments/success"
                               }),
        :callback_url => "#{HostUrl.context_host(@domain_root_account)}/accounts/#{@account.id}/payments/success"
    }

  end

  def get_charging_api_url
    PZ_Config::API_BASE + PZ_Config::API_CHARGING + "/" + PZ_Config::API_VERSION
  end

  def destroy
    Payment.find_by_identifier!(params[:id]).unsubscribe!
    redirect_to account_subscriptions_path(@account), notice: 'Recurring Profile Canceled'
  end

  def success
    @response_params = params
    # Incoming data can also be retrieved in the following manner using response_controller.rb or else in views we can display using @response_params array.

    # To check the validity of the response, call the validate function on
    # the ChargingResponse object. It verifies the hash returned in the response.
    @calculated_hash = validate()
    payment = Payment.find_by_merchant_transaction_id(@response_params[:merchant_transaction_id])
    if  @response_params[:hash] == @calculated_hash
      if payment.nil?
        flash[:error] = "Payment not found"
        redirect_to account_subscriptions_path(@account)
      elsif @response_params[:transaction_response_code] == 'SUCCESS'
        payment.subscription.paid_through = Date.today

        if payment.subscription.expire_on
          if payment.billing_type
            payment.subscription.expire_on += payment.billing_type.months.months
          else
            payment.subscription.expire_on += 1.months
          end
        else
          if payment.billing_type
            payment.subscription.expire_on  = Date.today + payment.billing_type.months.months
          else
            payment.subscription.expire_on = Date.today + 1.months
          end
        end

        payment.subscription.update_attributes(subscription_plan_id: payment.subscription_plan_id)
        update_lms_account(payment.subscription,payment.user_config)
        payment.completed = true
        payment.save!
        flash[:info] = "Payment Transaction Completed & Your Plan has been changed"
        redirect_to account_subscriptions_path(@account)
      else
        flash[:error] = "Transaction is not completed #{@response_params[:transaction_response_message]}"
        redirect_to account_subscriptions_path(@account)
      end
    else
      flash[:info] = "Generated hash not matched"
      redirect_to account_subscriptions_path(@account)
    end
  end

  def cancel
    payment = Payment.find_by_token! params[:token]
    payment.cancel!
    flash[:info] = 'Payment Request Canceled'
    redirect_to account_subscriptions_path(@account)
  end

  private

  def handle_callback
    payment = Payment.find_by_token! params[:token]
    @redirect_uri = yield payment
    if payment.popup?
      render :close_flow, layout: false
    end
  end


end
