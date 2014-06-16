class SubscriptionsController < ApplicationController
  before_filter :require_context
  include SubscriptionHelper

  def index
    if authorized_action(@account, @current_user, [:manage_account_settings, :manage_storage_quotas])
      @plans = @account.subscription_plans
      get_subscription
    end
  end

end
