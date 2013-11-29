class UserModuleEnrollment < ActiveRecord::Base
  include Workflow

  belongs_to :user
  belongs_to :context_module

  workflow do
    state :active do
      event :update, :transitions_to => :update
    end

    state :deleted
  end

  scope :active, where(:workflow_state => 'active')
  scope :deleted, where(:workflow_state => 'deleted')

end
