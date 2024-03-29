class GenerateChatResponseJob < ApplicationJob
  queue_as :default

  def perform(message_id:)
    @message = Message.find(message_id)
    @chat = @message.chat
    # this really doesn't belong in the controller, but we're still hackin    
    ai_res = if ENV.fetch('AI', "").downcase == 'disabled'
      sleep 2
      "skipping AI processing for rapid testing"
    else
      @message.run_ai
    end
    
    if ai_res 
      llm_response = @chat.messages.create(text: ai_res, is_bot: true)

      llm_response.broadcast_append_later_to(@chat, partial: 'messages/message_left',
      locals: {
        text: llm_response.text,
      }
    )
    end
  end
end
