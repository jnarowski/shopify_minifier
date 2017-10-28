class AddScripts < ActiveRecord::Migration[5.1]
  def change
    create_table :script_urls  do |t|
      t.string :url, null: false
      t.string :category, null: false
      t.integer :position, default: 0
      t.integer :shop_id
      t.timestamps
    end
  end
end
