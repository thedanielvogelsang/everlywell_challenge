class CreateExpertises < ActiveRecord::Migration[6.0]
  def change
    create_table :expertises do |t|
      t.text :website_text
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
