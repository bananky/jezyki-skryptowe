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
  LIMIT = 5

  def initialize(search_phrase)
    @query = search_phrase.strip
    raise ArgumentError, "Nie podano zapytania wyszukiwania" if @query.empty?
  end

  def run
    document = load_results_page
    check_results(document)
    extract_items(document)
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
      break if items.size >= LIMIT

      next unless element.is_a?(Nokogiri::XML::Element)

      title = element.at_css('h2')&.text&.strip
      price = element.at_css('.a-price .a-offscreen')&.text&.strip

      items << Item.new(title, price) if title && price
    end
    items
  end
end

# Uruchomienie z linii poleceń
if ARGV.empty?
  puts "Użycie: ruby amazon_scraper.rb <szukana fraza>"
  exit
end

phrase = ARGV.join(' ')
crawler = ProductCrawler.new(phrase)
results = crawler.run

puts JSON.pretty_generate(results)
