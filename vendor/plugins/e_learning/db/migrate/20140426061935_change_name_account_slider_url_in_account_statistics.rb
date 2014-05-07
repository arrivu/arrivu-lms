class ChangeNameAccountSliderUrlInAccountStatistics < ActiveRecord::Migration
  tag :predeploy
  def self.up
    rename_column :account_sliders, :account_slider_url, :account_slider_attachment_id
  end

  def self.down
    rename_column :account_sliders, :account_slider_attachment_id,:account_slider_url
  end
end
