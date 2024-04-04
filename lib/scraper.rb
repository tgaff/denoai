require 'capybara' 
require 'capybara/dsl'
require "capybara/cuprite"
require 'active_support'
require 'active_support/core_ext'
require 'debug'

class Scraper
  attr_reader :texts, :readers, :processed_addresses, :unprocessed_addresses
  attr_accessor :link_exclusion_patterns, :link_inclusion_patterns

  attr_reader :p

  def initialize(starting_url, link_exclusion_patterns: [], link_inclusion_patterns: [])
    @processed_addresses = Set.new
    @unprocessed_addresses = Set.new

    @initial_url = starting_url
    @texts = {}
    @link_exclusion_patterns = link_exclusion_patterns 
    @link_inclusion_patterns = link_inclusion_patterns 
  end

  def scrape(limit: 1)
    @unprocessed_addresses << @initial_url
    
    limit.times do |run_num|
      url = @unprocessed_addresses.first
      return if url.nil?
      puts "working run number: #{run_num + 1}: '#{url}'"
      scrape_internal(url)

      # done, mark it down
      @processed_addresses << url
      @unprocessed_addresses.delete url
    end
  end

  def scrape_internal(url)
    p = PageReader.new(url)
    @p = p
    p.text if p.text.blank? # retry once if empty
    
    @texts[url] = p.text
        
    links = filter_links p.links
    links.each do |link|
      puts link
      no_hash_link = link.split('#').first
      unless processed_addresses.include? no_hash_link
        unprocessed_addresses << no_hash_link        
      end
    end
  end

  def filter_links(links)
    links = links.filter(&:present?)
    return links if @link_exclusion_patterns.empty? && @link_inclusion_patterns.empty?

    temp = []
    unless @link_inclusion_patterns.empty?
      temp = links.filter do |link|
        @link_inclusion_patterns.any? { |pat| link.match pat }
      end
    end
    temp.filter do |link|
      @link_exclusion_patterns.none? { |exclusion_pattern| link.match exclusion_pattern }
    end
    temp
  end
end


class PageReader
  include Capybara::DSL

  attr_reader :texts, :possible_content_nodes

  Capybara.register_driver(:cuprite2) do |app|
    Capybara::Cuprite::Driver.new(app, window_size: [600, 2000])
  end

  def initialize(url)
    @texts = []
  
    Capybara.default_driver = :cuprite2
    begin
      visit url
    rescue Ferrum::PendingConnectionsError
      puts "page didn't load in time, retrying"
      sleep 0.5
      visit url
    end
  end

  def links  
    all('a', visible: :all).
      map { |node| node['href'] }.
      uniq.
      reject { |l| l.nil? || l.empty? }
  end

  def text
    all('div', wait: 30) # just to ensure its ready
    body = find("body")
    body.text # just to ensure page is ready

    locators = ['div.content', 'article', 'section']
    possible_content_nodes = []

    locators.each do |loc|
      if body.has_css?(loc)
        possible_content_nodes += body.all(loc)
      end
    end

    text_chunks = []
    @possible_content_nodes = possible_content_nodes
    possible_content_nodes.each do |node|
      text_chunks.push node.text
    end
    cleanup_content(text_chunks)

    @texts = text_chunks
  end

  # due to multiple valid text locators we can sometimes end up in a situation where one locator is inside another
  # this method finds the duplicate sub-text and removes it's node so it's only contained in the larger one
  def cleanup_content(text_chunks)
    # remove duplicates
    remove_indexes = []
    text_chunks.each_with_index do |this_text, this_index|
      fail "inconceivable" if remove_indexes.include? this_index
      text_chunks.each_with_index do |other_text, other_index|
        next if this_index == other_index # don't compare to self
        next if remove_indexes.include? other_index # don't compare to one already marked for deletion
        # mark to remove any nodes that have their entire text included in another node
        if other_text.include?(this_text)
          remove_indexes.push this_index
          break
        end
      end
    end

    # actual removal here
    remove_indexes.sort.reverse.each { |ind| text_chunks.delete_at(ind) }
    text_chunks
  end
end
