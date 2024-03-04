class AddVectorColumnToTexts < ActiveRecord::Migration[7.1]
  def change
    add_column :texts, :embedding, :vector,
      limit: LangchainrbRails
        .config
        .vectorsearch
        .llm
        .default_dimension
  end
end
