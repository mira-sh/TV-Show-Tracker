class AddRunningToShows < ActiveRecord::Migration
  def change
    add_column :shows, :running, :boolean
  end
end
