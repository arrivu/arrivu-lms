module SubscriptionHelper
  include ApplicationHelper
  # returns the daily cost of this plan.
  def daily_rate(options = {})
    yearly_rate(options) / 365
  end

  # returns the yearly cost of this plan.
  def yearly_rate(options = {})
    begin
      rate(options) * 12
    rescue
      rate * 12
    end
  end

  # returns the monthly cost of this plan.
  def monthly_rate(options = {})
    begin
      rate(options)
    rescue
      rate
    end
  end

  def paid?
    return false unless rate
    rate.cents > 0
  end

  def get_subscription
    @subscription = Subscription.find_by_account_id_and_subscribable_id_and_subscribable_type(@domain_root_account.id,
                                                                                              @account.id,Subscription::SUBSCRIBABLE_TYPE_ACCOUNT)
    if @subscription.nil?
      subscription_plan = @domain_root_account.subscription_plans.free.first
      @subscription = Subscription.create!(account_id: @account.id,
                                           subscription_plan_id: subscription_plan.id,
                                           subscribable_id: @account.id,
                                           subscribable_type: Subscription::SUBSCRIBABLE_TYPE_ACCOUNT)
      if @subscription.valid?

        @account.settings[:no_students] = params[:no_students]
        @account.settings[:no_teachers] = params[:no_teachers]
        @account.settings[:no_admins] = params[:no_admins]
        @account.settings[:no_courses] = params[:no_courses]
        @account.default_storage_quota_mb = params[:storage]
        @account.settings[:unlimited] = false unless params[:unlimited] == 'true'
        if @account.save!
          render :json => @account.to_json
        else
          render :json => @account.errors ,:status => :bad_request
        end

      end
    end
  end

end
