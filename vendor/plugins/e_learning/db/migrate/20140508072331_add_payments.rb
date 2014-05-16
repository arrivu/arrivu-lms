class AddPayments < ActiveRecord::Migration
  tag :predeploy
  def self.up
    create_table :payments do |t|
      t.belongs_to :course, :limit => 8
      t.belongs_to :user, :limit => 8
      t.integer :amount, default: 1
      t.string :token, :identifier, :payer_id
      t.boolean :recurring, :digital, :popup, :completed, :canceled, default: false
      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
