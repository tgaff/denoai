# == Schema Information
#
# Table name: libraries
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_libraries_on_name  (name)
#
require 'rails_helper'

RSpec.describe Library, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
