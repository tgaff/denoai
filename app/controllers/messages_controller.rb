class MessagesController < ApplicationController
  before_action :set_chat

  def create
    @message = @chat.messages.create(message_params)
    respond_to do |format|
      format.turbo_stream
      format.html { head :no_content }
    end

    run_ai
  end

  def run_ai
    GenerateChatResponseJob.perform_later(message_id: @message.id)
  end

  private

  def message_params
    params.require('message').permit('text')
  end

  def set_chat
    @chat = Chat.find(params[:chat_id])
  end

end
