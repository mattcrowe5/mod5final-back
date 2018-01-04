class Shows < ActiveRecord::Migration[5.1]
  def change
    create_table :shows do |t|
      t.string :venue
      t.string :date
      t.string :time
      t.string :name
      t.string :link
      t.string :artist
      t.string :photo
    end
  end
end
