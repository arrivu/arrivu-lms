class FeatureSet < ActiveRecord::Base
 attr_accessible :account_id,:name ,:no_students,:no_teachers,:no_admins,:no_courses,:storage,:unlimited

 validates_presence_of :name,:account_id

 belongs_to :account
 has_many :subscription_plans

end
