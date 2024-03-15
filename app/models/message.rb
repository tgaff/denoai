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


  def chat_role
    is_bot? ? "assistant" : "user"
  end

  def as_llm_chat_message
    { role: chat_role, content: text }
  end

  
  def run_ai
    convo = chat.messages.map(&:as_llm_chat_message)

    # thread = Langchain::Thread.new
    llm = Langchain::LLM::OpenAI.new(
      api_key: ENV["OPENAI_API_KEY"],
    )

    # llm.chat(messages: convo).ask(question: text)
  
    # def ask(question:, k: 4, &block)
    # search_results = similarity_search(query: text, k: 4)
    
    search_results = chat.library.texts.similarity_search(text, k: 4)

    context = search_results.map do |sr|
      sr.content.to_s
    end
    context = context.join("\n---\n")
    # debugger


    prompt = Langchain::Vectorsearch::Base.new(llm: llm).generate_rag_prompt(question: text, context: context)

    messages = [{role: "user", content: prompt}] + convo
    response = llm.chat(messages: messages)

    response.context = context
    response.completion

  end

  # def run_ai
  #   convo = chat.messages.map(&:as_llm_chat_message)

  #   thread = Langchain::Thread.new
  #   llm = Langchain::LLM::OpenAI.new(
  #     api_key: ENV["OPENAI_API_KEY"],
  #   )

  #   llm.chat(messages: convo).ask(question: text)
  # end
end
