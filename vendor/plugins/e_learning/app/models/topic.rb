class Topic < ActiveRecord::Base
  attr_accessible :name,:color,:account_id,:parent_topic_id,:root_topic_id ,:parent_id
  has_ancestry
  has_many :courses
  belongs_to :account
  validates_presence_of :name, presence: true, length: { maximum: 100 }

  def self.json_tree(nodes)
    nodes.map do |node, sub_nodes|
      {:name => node.name, :id => node.id, :children => json_tree(sub_nodes).compact}
    end
  end
end
