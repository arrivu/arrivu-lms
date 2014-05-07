class CreateAccountSliders < ActiveRecord::Migration
  tag :predeploy
  def self.up
    create_table :account_sliders do |t|
      t.integer :account_id, :limit => 8
      t.string :account_slider_url
      t.timestamps
    end
  end

  def self.down
    drop_table :account_sliders
  end
end
