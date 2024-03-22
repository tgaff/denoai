class RenameTypeToSourceTypeOnText < ActiveRecord::Migration[7.1]
  def change
    rename_column :texts, :type, :source_type
  end
end
