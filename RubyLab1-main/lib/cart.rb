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

  def save_to_csv
    csv_file_path = File.join(@output_dir, 'electric_vehicle_data.csv')
    CSV.open(csv_file_path, 'wb') do |csv|
      csv << ['vin_1_10', 'country', 'city', 'state', 'postal']  # Header row
      @items.each do |item|
        csv << [item[:vin_1_10], item[:country], item[:city], item[:state], item[:postal]]  # Data rows
      end
    end
    LoggerManager.log_processed_file("Saved items to CSV: #{csv_file_path}")
  end

  # Save items to JSON
  def save_to_json
    json_file_path = File.join(@output_dir, 'electric_vehicle_data.json')
    File.open(json_file_path, 'w') do |file|
      file.write(JSON.pretty_generate(@items))  # Write JSON data in a readable format
    end
    LoggerManager.log_processed_file("Saved items to JSON: #{json_file_path}")
  end

  # Save items to YAML
  def save_to_yaml
    yaml_file_path = File.join(@output_dir, 'electric_vehicle_data.yml')
    File.open(yaml_file_path, 'w') do |file|
      file.write(YAML.dump(@items))  # Use YAML.dump to serialize the data
    end
    LoggerManager.log_processed_file("Saved items to YAML: #{yaml_file_path}")
  end

  private

  attr_accessor :items
end
