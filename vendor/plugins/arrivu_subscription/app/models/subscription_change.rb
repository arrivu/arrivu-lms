class SubscriptionChange < ActiveRecord::Base
  belongs_to :subscribable, :polymorphic => true

  belongs_to :original_subscription_plan, :class_name => "SubscriptionPlan"
  belongs_to :new_subscription_plan, :class_name => "SubscriptionPlan"

  composed_of :new_rate, :class_name => 'Money', :mapping => [ %w(new_rate_cents cents) ], :allow_nil => true
  composed_of :original_rate, :class_name => 'Money', :mapping => [ %w(original_rate_cents cents) ], :allow_nil => true

  validates_presence_of :reason
  validates_inclusion_of :reason, :in => %w(new upgrade downgrade expiration cancellation)

  attr_accessible :subscribable_id,:subscribable_type, :reason, :new_subscription_plan_id, :new_rate, :original_rate,:original_subscription_plan_id
end