class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.references :chat, null: false, foreign_key: true
      t.string :text, null: false
      t.boolean :is_bot, null: false, default: false

      t.timestamps
    end
  end
end
