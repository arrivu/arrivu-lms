class AddTypeToWikipages < ActiveRecord::Migration
  tag :predeploy
  def self.up
    add_column :wiki_pages, :wiki_type, :string
    add_column :wiki_pages, :allow_comments, :boolean
  end

  def self.down
    remove_column :wiki_pages, :wiki_type
    remove_column :wiki_pages, :allow_comments
  end

end
