class MessagesController < ApplicationController
  before_action :set_chat

  def create
    @message = @chat.messages.create(message_params)
    respond_to do |format|
      # format.turbo_stream
      format.html { head :no_content }
    end

    @message.broadcast_append_later_to(@chat, partial: 'messages/message_right',
      locals: {
        text: @message.text,
      }
    )
 
    # this really doesn't belong in the controller, but we're still hackin
    ai_res = @message.run_ai
    if ai_res 
      @message = @chat.messages.create(text: ai_res, is_bot: true)

      @message.broadcast_append_later_to(@chat, partial: 'messages/message_left',
      locals: {
        text: @message.text,
      }
    )
    end
  end

  private

  def message_params
    params.require('message').permit('text')
  end

  def set_chat
    @chat = Chat.find(params[:chat_id])
  end

end
