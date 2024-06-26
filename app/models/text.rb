# == Schema Information
#
# Table name: texts
#
#  id          :bigint           not null, primary key
#  content     :text
#  embedding   :vector(1536)
#  name        :string           not null
#  source_type :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  library_id  :bigint           not null
#
# Indexes
#
#  index_texts_on_library_id  (library_id)
#
# Foreign Keys
#
#  fk_rails_...  (library_id => libraries.id)
#
class Text < ApplicationRecord
  vectorsearch

  after_save :upsert_to_vectorsearch

  belongs_to :library

  # for use on the collection of Texts
  def self.to_export_json
    select(:name, :content, :source_type).to_json
  end
end
