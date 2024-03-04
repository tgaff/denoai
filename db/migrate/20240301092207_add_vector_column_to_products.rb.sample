class AddVectorColumnToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :embedding, :vector,
      limit: LangchainrbRails
        .config
        .vectorsearch
        .llm
        .default_dimension
  end
end
