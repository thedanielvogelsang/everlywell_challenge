class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :url
      t.string :tiny_url

      t.timestamps
    end
  end
end
