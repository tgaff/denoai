class ScanLzGuidesJob < ApplicationJob
  queue_as :default

  URL="https://github.com/labzero/guides.git"

  EXCLUDE_FILES = [
    "README.md"
  ]
    
  def perform(*args)
    fetch_repo

    read_repo

    delete_repo
  end

  def library
    @library ||= Library.find_or_create_by(name: "lz")
  end

  def read_repo
    file_paths = Dir.glob("**/*.md")
    file_paths.each do |file|
      next if EXCLUDE_FILES.include?(file)
      text = File.read file
      chunks = Langchain::Chunker::Markdown.new(text).chunks
      chunks.each do |chunk|
        filename = file.split('/').last
        title = "Guides: #{filename} - #{chunk.text[0,20]}"
        puts title
        record = library.texts.find_or_create_by(name: title)
        record.content = chunk.text
        record.source_type = 'md'
        record.save
      end
    end
  end

  def delete_repo
    Dir.chdir(Rails.root.to_s)
    FileUtils.remove_dir(temp_dir, true) # true - ignore errors
  end

  def fetch_repo
    Dir.chdir(temp_dir)
    unless system("git clone #{URL}")
      fail "Failed to clone"
    end
  end

  def temp_dir
    @temp_dir ||= Dir.mktmpdir("repo-fetch-", "/tmp")
  end
end
