#!/usr/bin/env ruby

require 'nokogiri'
require 'open-uri'
require 'json'

Item = Struct.new(:name, :cost) do
  def to_json(*args)
    { title: name, price: cost }.to_json(*args)
  end
end

class ProductCrawler
  BASE_URL = "https://www.amazon.pl"
  HEADERS = {
    'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36'
  }

  def initialize(search_phrase, max_results = 5)
    @query = search_phrase.strip.gsub(/\s+/, ' ')
    raise ArgumentError, "Wyszukiwanie nie może być puste" if @query.empty?
    @max_results = max_results
  end

  def run
    puts "Szukam produktów dla: '#{@query}'"
    doc = load_results_page
    check_results(doc)
    extract_items(doc)
  end

  private

  def load_results_page
    search_url = "#{BASE_URL}/s?k=#{URI.encode_www_form_component(@query)}"
    Nokogiri::HTML(URI.open(search_url, HEADERS))
  rescue OpenURI::HTTPError => e
    abort "Błąd HTTP: #{e.message}"
  rescue StandardError => e
    abort "Inny błąd: #{e.message}"
  end

  def check_results(doc)
    unless doc.at_css('.s-search-results .s-result-item')
      abort "Brak wyników dla zapytania: #{@query}"
    end
  end

  def extract_items(doc)
    items = []
    doc.css('.s-result-item').each do |element|
      break if items.size >= @max_results

      title = element.at_css('h2')&.text&.strip
      price = element.at_css('.a-price .a-offscreen')&.text&.strip

      items << Item.new(title, price) if title && price
    end
    items
  end
end

if ARGV.empty?
  puts "Użycie: ruby amazon_scraper.rb <szukane słowa kluczowe>"
  exit
end

phrase = ARGV.join(' ')
crawler = ProductCrawler.new(phrase)
results = crawler.run

puts
puts JSON.pretty_generate(results)
