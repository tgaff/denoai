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
  end

  private

  def message_params
    params.require('message').permit('text')
  end

  def set_chat
    @chat = Chat.find(params[:chat_id])
  end

end
