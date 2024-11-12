require 'csv'
require 'json'  # To handle JSON export
require 'yaml'  # To handle YAML export
require_relative './item_container'  # Ensure the ItemContainer module is included
require_relative './api_parser'      # Ensure ApiParser is required correctly

class Cart
  include ItemContainer  # This makes methods like add_item available

  def initialize(output_dir)
    @output_dir = output_dir
    @items = []  # Initialize the items array
  end

  def start_parsing(webparsing_config)
    parser = ApiParser.new(webparsing_config)  # Use ApiParser to fetch data
    items = parser.start_parse
    items.each { |item| add_item(item) }  # Add items to the cart
  end
