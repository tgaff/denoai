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
require 'rails_helper'

RSpec.describe Text, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
