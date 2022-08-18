class AddStatusToPostVideos < ActiveRecord::Migration[6.1]
  def change
    add_column :post_videos, :status, :integer, default: 0, null: false
  end
end
