class JsonImportJob < ApplicationJob
  queue_as :default

  ALLOWED_KEYS = ["content", "name", "source_type"]
  REQUIRED_KEYS = ["content", "name"]

  def perform(library_id:, json:)
    # Do something later
    library = Library.find(library_id)

    fail "Invalid JSON" unless self.class.is_valid_json? json

    import_records = JSON.parse json
    # ensure only valid keys get through
    import_records.map! { |node| node.slice(*ALLOWED_KEYS) }
    import_records.each do |node|
      # inneficient but we're not going for size at this point
      begin
        library.texts.find_or_create_by(name: node["name"]) do |text|
          text.assign_attributes(node)
        end
      rescue StandardError => e
        Rails.logger.error "Encountered error: #{e} at node \"#{node&.strip}\n"
      end
    end
  end

  def self.is_valid_json?(json_string)
    json = JSON.parse json_string
    return false unless json.is_a? Array
    # ensure only valid keys get through
    json.map! { |node| node.slice(*ALLOWED_KEYS) }
    return false unless json.count > 0
    required_key_count = REQUIRED_KEYS.length
    return false if json.any? { |n| n.keys.intersection(REQUIRED_KEYS).length != required_key_count }
  
    true
  rescue JSON::ParserError
    return false
  end
end
