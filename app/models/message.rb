# == Schema Information
#
# Table name: messages
#
#  id         :bigint           not null, primary key
#  is_bot     :boolean          default(FALSE), not null
#  text       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  chat_id    :bigint           not null
#
# Indexes
#
#  index_messages_on_chat_id  (chat_id)
#
# Foreign Keys
#
#  fk_rails_...  (chat_id => chats.id)
#
class Message < ApplicationRecord
  belongs_to :chat
  validates :text, presence: true
end
