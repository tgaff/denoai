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
class Library < ApplicationRecord
end
