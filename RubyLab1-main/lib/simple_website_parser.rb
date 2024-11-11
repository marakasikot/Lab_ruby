require 'nokogiri'
require 'open-uri'
require 'logger'

class SimpleWebsiteParser
  def initialize(config)
    @config = config
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::INFO
  end

  def start_parse
    start_page = @config['start_page']
    product_selector = @config['product_selector']
    product_name_selector = @config['product_name_selector']
    product_price_selector = @config['product_price_selector']
    product_description_selector = @config['product_description_selector']
    product_image_selector = @config['product_image_selector']
    product_rooms_selector = @config['product_rooms_selector']
    product_location_selector = @config['product_location_selector']
    

    doc = Nokogiri::HTML(URI.open(start_page))
    products = doc.css(product_selector)
    rental_items = []

    products.each do |product|
      product_name = product.at_css(product_name_selector).text.strip rescue nil
      product_price = product.at_css(product_price_selector).text.strip rescue nil
      product_description = product.at_css(product_description_selector).text.strip rescue nil
      product_image = product.at_css(product_image_selector)['href'] rescue nil
      product_rooms = product.at_css(product_rooms_selector).text.strip rescue nil
      product_location = product.at_css(product_location_selector).text.strip rescue nil

      rental_item = RentalItem.new(
        price: product_price,
        address: product_name,
        square_meters: "N/A",
        rooms: product_rooms,
        image_path: "N/A"
      )

      rental_items << rental_item
    end

    return rental_items
  end
end
