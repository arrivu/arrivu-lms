class CreateStaticContents < ActiveRecord::Migration
  def self.up
    create_table :static_contents do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :static_contents
  end
end
