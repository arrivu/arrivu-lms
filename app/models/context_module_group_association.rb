class ContextModuleGroupAssociation < ActiveRecord::Base
  belongs_to :context_module_group
  belongs_to :context_module
  validates_presence_of :context_module_id,:context_module_group_id
end
