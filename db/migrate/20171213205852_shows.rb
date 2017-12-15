class Shows < ActiveRecord::Migration[5.1]
  def change
    create_table :shows do |t|
      t.string :venue
      t.string :date
      t.string :image
      t.string :address
      t.string :link
    end
  end
end
