class AddScriptIgnore < ActiveRecord::Migration[5.1]
  def change
    add_column :script_urls, :ignored, :boolean, default: false
  end
end
