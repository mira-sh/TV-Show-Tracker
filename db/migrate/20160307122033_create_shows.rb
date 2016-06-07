class CreateShows < ActiveRecord::Migration
  def change
    create_table :shows do |t|
      t.string :name
      t.string :description
      t.string :image
      t.string :lastAirDate

      t.timestamps null: false
    end
  end
end
