require 'json'
require 'csv'
require 'yaml'
require_relative './item_container'
require_relative './logger_manager'
require_relative './rental_item'

class Cart
  include ItemContainer
  include Enumerable

  attr_reader :items, :output_dir

  def initialize(output_dir = 'output')
    @items = []
    @output_dir = output_dir
    Dir.mkdir(output_dir) unless Dir.exist?(output_dir)
    LoggerManager.log_processed_file("Initialized Cart instance with output directory: #{output_dir}")
  end

  def each(&block)
    items.each(&block)
  end

  def save_to_file(filename = 'items.txt')
    file_path = File.join(output_dir, filename)
    File.open(file_path, 'w') { |file| items.each { |item| file.puts(item.to_s) } }
    LoggerManager.log_processed_file("Saved items to #{file_path}")
  end

  def save_to_json(filename = 'items.json')
    file_path = File.join(output_dir, filename)
    File.write(file_path, JSON.pretty_generate(items.map(&:to_h)))
    LoggerManager.log_processed_file("Saved items to #{file_path}")
  end

  def save_to_csv(filename = 'items.csv')
    file_path = File.join(output_dir, filename)
    CSV.open(file_path, 'w') do |csv|
      csv << items.first.to_h.keys if items.any?
      items.each { |item| csv << item.to_h.values }
    end
    LoggerManager.log_processed_file("Saved items to #{file_path}")
  end

  def save_to_yml(directory = 'items_yml')
    dir_path = File.join(output_dir, directory)
    Dir.mkdir(dir_path) unless Dir.exist?(dir_path)
    items.each_with_index do |item, index|
      file_path = File.join(dir_path, "item_#{index + 1}.yml")
      File.write(file_path, item.to_h.to_yaml)
    end
    LoggerManager.log_processed_file("Saved items to #{dir_path} as YAML files")
  end

  def start_parsing(webparsing_config)
    parser = SimpleWebsiteParser.new(webparsing_config)
    items = parser.start_parse

    items.each { |item| add_item(item) }
  end

  def generate_test_items(count = 5)
    count.times { add_item(RentalItem.generate_fake) }
    LoggerManager.log_processed_file("Generated #{count} test items")
  end
end
