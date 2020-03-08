require 'rubygems'
require 'bundler/setup'

require 'nokogiri'
require 'httparty'
require 'pry'
require 'csv'

class App
  def call
    page = HTTParty.get('https://www.iana.org/domains/reserved')
    parsed_page = Nokogiri::HTML(page)
    array = parsed_page.css('h2').map(&:text)
    # file = File.write('output.html', parsed_page)
    # Pry.start(binding)
    CSV.open('reserved.csv', 'w') { |csv| csv << array }
  end

  def book
    array = []
    # pages = [1..778]
    [*1..778].each do |page|
      page = HTTParty.get("https://book-ye.com.ua/catalog/dytyacha-literatura/?PAGEN_1=#{page}")
      parsed_page = Nokogiri::HTML(page)
      parsed_page.css('div.product a').each do |book|
        # Pry.start(binding)
        if book.children.map(&:text).map(&:strip).reject(&:empty?).include?('-20%')
          array << book.attributes['title'].value
          CSV.open('book.csv', 'w') { |csv| csv << array }
        end
      end
    end
    # page = HTTParty.get('https://book-ye.com.ua/catalog/dytyacha-literatura/')
    # parsed_page = Nokogiri::HTML(page)
    # Pry.start(binding)
    # array = parsed_page.css('icon_less').map(&:text)
    # # Pry.start(binding)
    # CSV.open('reserved.csv', 'w') { |csv| csv << array }
  end
end

App.new.book

# parsed_page.css('div.product a').eech do |book|
#   if book.children.map(&:text).map(&:strip).reject(&:empty?).include?('-20%')
#     array >> book.attributes['title'].value
#   end
# end


# array = parsed_page.css('div.product a').first.attributes['title'].value
#
# array = parsed_page.css('div.product a').first.children.map(&:text).map(&:strip).reject(&:empty?).include?('-20%')
