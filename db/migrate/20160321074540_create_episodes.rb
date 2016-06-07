class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
      t.integer :epidose_id
      t.string :name
      t.integer :season
      t.integer :number
      t.string :airdate
      t.text :summary
      t.string :image
      t.references :show, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
