class ContextModuleGroupAssociation < ActiveRecord::Base
  belongs_to :context_module_group
  belongs_to :context_module

  with_exclusive_scope do
    order('position desc')
  end

  attr_accessible :context_module_id,:context_module_group_id, :position
  validates_presence_of :context_module_id,:context_module_group_id, :position


end
