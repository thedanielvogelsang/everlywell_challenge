class CreateTinyUrls < ActiveRecord::Migration[6.0]
  def change
    create_table :tiny_urls do |t|
      t.string :original_url
      t.string :shortened_url

      t.timestamps
    end
  end
end
