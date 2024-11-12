require 'net/http'
require 'json'
require 'uri'

class ApiParser
  def initialize(config)
    @config = config
  end
  def parse_data(data)
    vin_1_10 = data['vin_1_10']  "N/A"  # Default to "N/A" if it's nil
    country = data['country']  "Unknown"
    city = data['city']  "Unknown"
    state = data['state']  "Unknown"
    postal = data['postal'] || "Unknown"
    { vin_1_10: vin_1_10, country: country, city: city, state: state, postal: postal }
  end


  def start_parse
    # URL for the web page containing the data
    url = 'https://data.wa.gov/api/views/f6w7-q2d2/rows.json'
    data = fetch_data_from_api(url)
    parse_data(data)
  end

  private

  def fetch_data_from_api(url)
    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri)

    if response.is_a?(Net::HTTPSuccess)
      json_data = JSON.parse(response.body)
      puts "Raw API Response: #{json_data}"  # Add this line for debugging
      return json_data
    else
      raise "Failed to fetch data from API"
    end
  end
