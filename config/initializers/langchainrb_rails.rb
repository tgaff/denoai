# frozen_string_literal: true

LangchainrbRails.configure do |config|
  config.vectorsearch = Langchain::Vectorsearch::Pgvector.new(
    llm: Langchain::LLM::OpenAI.new(
      api_key: Rails.application.credentials.dig(:openai_key),
      # using text-embedding-3-small because the default ada-2 fails due to a bug in inappropriately sending dimensions
      default_options: { embeddings_model_name: "text-embedding-3-small" }
    )
  )
end
