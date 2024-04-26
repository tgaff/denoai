class LzChatsController < ChatsController
  before_action :set_library
  
  def index
    @chats = @library.chats 
    render 'index' 
  end

  def new
    @chat = @library.chats.new  
  end

  private

  def set_library
    @library ||= Library.find_by(name: 'lz')
  end

  def set_chat
    @chat = Chat.find_by(id: params[:id], library_id: @library.id)
  end
  def set_libraries
    @libraries = Library.where(name: 'lz')
  end
end
