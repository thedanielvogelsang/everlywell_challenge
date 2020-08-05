class AddSanitizedUrlToTinyUrl < ActiveRecord::Migration[6.0]
  def change
    add_column :tiny_urls, :sanitized_url, :string
  end
end
