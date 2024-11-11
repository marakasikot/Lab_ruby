require 'faker'
require_relative './logger_manager'

class RentalItem
  include Comparable

  attr_accessor :price, :address, :square_meters, :rooms, :image_path

  def initialize(params = {})
    @price = params[:price] || 0.0
    @address = params[:address] || 'Адреса відсутня'
    @square_meters = params[:square_meters] || 0
    @rooms = params[:rooms] || 1
    @image_path = params[:image_path] || 'default_image.jpg'

    LoggerManager.log_processed_file("Ініціалізовано об'єкт RentalItem з адресою #{@address}")

    yield(self) if block_given?
  end

  def <=>(other)
    price <=> other.price
  end

  def to_s
    "Оренда: Ціна: #{price} грн, Адреса: #{address}, Площа: #{square_meters} м², Кімнат: #{rooms}, Зображення: #{image_path}"
  end

  def to_h
    instance_variables.each_with_object({}) do |var, hash|
      hash[var.to_s.delete('@')] = instance_variable_get(var)
    end
  end

  def inspect
    "#<RentalItem: #{to_h}>"
  end

  alias_method :info, :to_s

  def update
    yield(self) if block_given?
  end

  def self.generate_fake
    new(
      price: Faker::Number.between(from: 5000, to: 20000),
      address: Faker::Address.full_address,
      square_meters: Faker::Number.between(from: 30, to: 200),
      rooms: Faker::Number.between(from: 1, to: 5),
      image_path: "images/#{Faker::Lorem.word}.jpg"
    )
  end
end
