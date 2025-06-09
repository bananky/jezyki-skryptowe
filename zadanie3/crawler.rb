#!/usr/bin/env ruby

require 'nokogiri'
require 'open-uri'
require 'json'
require 'cgi'

Item = Struct.new(:title, :price, :asin, :dimensions, :link) do
  def to_json(*options)
    {
      title: title,
      price: price,
      asin: asin,
      dimensions: dimensions,
      link: link
    }.to_json(*options)
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
      asin = element['data-asin']
      next unless title && price && asin && !asin.empty?

      dimensions = scrape_dimensions(asin)
      product_link = "#{BASE_URL}/dp/#{asin}"

      items << Item.new(title, price, asin, dimensions, product_link)
      sleep(rand(0.5..1.0))
    end

    items
  end

  def scrape_dimensions(asin)
    url = "#{BASE_URL}/dp/#{asin}"
    begin
      doc = Nokogiri::HTML(URI.open(url, HEADERS))
    rescue OpenURI::HTTPError => e
      puts "Błąd ładowania strony produktu #{asin}: #{e.message}"
      return nil
    end

    dimension = nil

    doc.css('#productDetails_techSpec_section_1 tr').each do |row|
      key = row.at_css('th')&.text&.strip
      value = row.at_css('td')&.text&.strip
      if key&.downcase&.include?('wymiary') || key&.downcase&.include?('dimensions')
        dimension = value
        break
      end
    end

    if dimension.nil?
      doc.css('#prodDetails tr').each do |row|
        key = row.at_css('td.label')&.text&.strip
        value = row.at_css('td.value')&.text&.strip
        if key&.downcase&.include?('wymiary') || key&.downcase&.include?('dimensions')
          dimension = value
          break
        end
      end
    end

    dimension
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
