class SubscriptionPlansController < ApplicationController
  before_filter :require_context
  include SubscriptionHelper


  def subscribe
    if authorized_action(@account, @current_user, [:manage_account_settings, :manage_storage_quotas])
      @subscription_plan = SubscriptionPlan.find(params[:id])
      @subscription = Subscription.find(params[:subscription_id])
      if @subscription_plan.paid?
        redirect_to account_payment_confirm_path(@account,@subscription,subscription_plan_id: @subscription_plan.id,billing: params[:subscription][:billing])
      else
        @subscription.update_attributes!(subscription_plan_id: @subscription_plan.id,expire_on: nil)
        if @subscription.valid?
          update_lms_account(@account,@subscription_plan)
          flash[:success] = "Your Subscription Plan has been changed"
          redirect_to account_subscriptions_path(@account)
        end
      end
    end
  end

  def pre_index
    @organizations = Organization.all
    if params['/subscription_plans'].present? and params['/subscription_plans']['account_id'].present?
    redirect_to subscription_plans_path(account_id: params['/subscription_plans']['account_id'])
    end
  end

  def index
    @subscription_plan = SubscriptionPlan.new
    @org = Organization.find(params[:account_id])
    @subscription_plans = @org.subscription_plans
    @feature_sets = @org.feature_sets
  end

  def create
    @subscription_plan = SubscriptionPlan.new(params[:subscription_plan])
    if @subscription_plan.save
      flash[:notice] = "Successfully created SubscriptionPlan."
      redirect_to subscription_plans_path
    else
      @subscription_plans = SubscriptionPlan.all
      render :action => 'index'
    end
  end

  def edit
    @subscription_plan = SubscriptionPlan.find(params[:id])
    @feature_sets =@account.feature_sets
  end

  def update
    @subscription_plan = SubscriptionPlan.find(params[:id])
    if @subscription_plan.update_attributes(params[:subscription_plan])
      flash[:notice] = "Successfully updated SubscriptionPlan."
      redirect_to subscription_plans_path
    else
      render :action => 'edit'
    end
  end

  def destroy
    @subscription_plan = SubscriptionPlan.find(params[:id])
    @subscription_plan.destroy
    flash[:notice] = "Successfully destroyed SubscriptionPlan."
    redirect_to subscription_plans_path
  end


end
