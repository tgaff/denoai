class CreateTexts < ActiveRecord::Migration[7.1]
  def change
    create_table :texts do |t|
      t.text :content
      t.references :library, null: false, foreign_key: true
      t.string :type
      t.string :name, null: false

      t.timestamps
    end
  end
end
