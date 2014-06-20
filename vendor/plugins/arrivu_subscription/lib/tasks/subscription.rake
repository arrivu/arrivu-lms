namespace :db do

  task seed_subscription: :environment do
#   Billing types
    @domain_root_account = Account.default
    @domain_root_account.billing_types.create(billing_type: "annually",discount_percentage: '20',months: 12)
    @domain_root_account.billing_types.create(billing_type: "half-yearly",discount_percentage: '10',months: 6)
    @domain_root_account.billing_types.create(billing_type: "quarterly",discount_percentage: '5',months: 3)
    @domain_root_account.billing_types.create(billing_type: "month-by-month",discount_percentage: '0',months: 1)

    #   Feature sets
    @f1= FeatureSet.create(account_id: @domain_root_account.id,
                           name: "Free",
                           no_students: 100,
                           no_teachers: 2,
                           no_admins: 1,
                           no_courses: 2,
                           storage: 1000,
                           unlimited: false)
    @f2= FeatureSet.create(account_id: @domain_root_account.id,
                           name: "Plus",
                           no_students: 500,
                           no_teachers: 100,
                           no_admins: 10,
                           no_courses: 25,
                           storage: 50000,
                           unlimited: false)
    @f3= FeatureSet.create(account_id: @domain_root_account.id,
                           name: "Premium",
                           no_students: 1000,
                           no_teachers: 200,
                           no_admins: 25,
                           no_courses: 200,
                           storage: 1000000,
                           unlimited: false)

    SubscriptionPlan.create(account_id: @domain_root_account.id,
                            feature_set_id: @f1.id,
                            name: 'Free',
                            rate_cents: 0

    )
    SubscriptionPlan.create(account_id: @domain_root_account.id,
                            feature_set_id: @f2.id,
                            name: 'Plus',
                            rate_cents: 10

    )
    SubscriptionPlan.create(account_id: @domain_root_account.id,
                            feature_set_id: @f3.id,
                            name: 'Premium',
                            rate_cents: 100

    )



  end


end
