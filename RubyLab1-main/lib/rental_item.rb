# lib/rental_item.rb
class RentalItem
  attr_accessor :vin_1_10, :country, :city, :state, :postal

  def initialize(vin_1_10:, country:, city:, state:, postal:)
    @vin_1_10 = vin_1_10
    @country = country
    @city = city
    @state = state
    @postal = postal
  end
end
