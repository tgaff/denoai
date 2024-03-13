# == Schema Information
#
# Table name: chats
#
#  id         :bigint           not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  library_id :bigint           not null
#
# Indexes
#
#  index_chats_on_library_id  (library_id)
#
# Foreign Keys
#
#  fk_rails_...  (library_id => libraries.id)
#
require 'rails_helper'

RSpec.describe Chat, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
