class AddIdToShows < ActiveRecord::Migration
  def change
    add_column :shows, :show_id, :integer
  end
end
