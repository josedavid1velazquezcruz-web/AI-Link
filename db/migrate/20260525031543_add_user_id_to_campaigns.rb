class AddUserIdToCampaigns < ActiveRecord::Migration[7.1]
  def change
    add_column :campaigns, :user_id, :integer
  end
end
