class ScanLzSiteJob < ApplicationJob
  queue_as :default

  LIMIT = 999

  def perform(*args)
    @library = Library.find_by(name: 'lz')
    return unless @library.present?
    
    delete_old_web_scans

    url = "https://qa.labzero.com"
    texts = fetch_texts_from_web(url)

    # texts should be a hash of title -> text
    texts.each do |title, text|
      @library.texts.create(name: title, content: text)
    end

  end

  def fetch_texts_from_web(url)
    exclusion_patterns = ["unsplash.com", /twitter/]
    s = Scraper.new(url, link_exclusion_patterns: exclusion_patterns, link_inclusion_patterns: ['qa.labzero.com'])
    s.scrape(limit: LIMIT)
  
    s.texts.each do |t|
      puts t
      puts "\n"
    end
    return s.texts
  end
  
  def delete_old_web_scans
    @library.texts.where('name like ?', "Guides:%").destroy_all
  end
end
