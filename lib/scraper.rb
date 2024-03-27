require 'capybara' 
require 'capybara/dsl'
require "capybara/cuprite"

class Scraper
  attr_reader :texts, :readers
  attr_accessor :link_exclusion_patterns, :link_inclusion_patterns

  attr_reader :p

  def initialize(starting_url, link_exclusion_patterns: [], link_inclusion_patterns: [])
    @initial_url = starting_url
    @texts = []
    @link_exclusion_patterns = link_exclusion_patterns 
    @link_inclusion_patterns = link_inclusion_patterns 
  end

  def scrape(limit: 0)
    p = PageReader.new(@initial_url)
    @p = p
    @texts.push p.text
    links = filter_links p.links
  end

  def filter_links(links)
    return links if @link_exclusion_patterns.empty? && @link_inclusion_patterns.empty?

    temp = links.filter do |link|
      @link_inclusion_patterns.any? { |pat| link.match pat }
    end
    temp.filter do |link|
      @link_exclusion_patterns.none? { |exclusion_pattern| link.match exclusion_pattern }
    end
    temp
  end
end


class PageReader
  include Capybara::DSL

  attr_reader :texts

  def initialize(url)
    Capybara.default_driver = :cuprite
    visit url
    @texts = []
  end

  def links  
     all('a').map { |node| node['href'] }
  end

  def text
    body = find("body")
    locators = ['div.content', 'article']
    possible_content_nodes = []

    locators.each do |loc|
      if body.has_css?(loc)
        possible_content_nodes += body.all(loc)
      end
    end

    possible_content_nodes.each do |node|
      @texts.push node.text
    end
    @texts
  end
end