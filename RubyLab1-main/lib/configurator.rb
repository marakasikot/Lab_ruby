class Configurator
  def configure(run_website_parser:, run_save_to_csv:, run_save_to_json:, run_save_to_yaml:, run_save_to_mongodb:)
    @actions = {
      website_parser: run_website_parser,
      save_to_csv: run_save_to_csv,
      save_to_json: run_save_to_json,
      save_to_yaml: run_save_to_yaml,
      save_to_mongodb: run_save_to_mongodb
    }
    puts "Actions configured: #{@actions}"  # Debugging line to check the configuration
  end

  def run_actions(cart, webparsing_config, mongodb_config)
    if @actions.nil?
      raise "Actions were not properly configured"
    end
    
    if @actions[:website_parser] == 1
      cart.start_parsing(webparsing_config)
    end
    if @actions[:save_to_csv] == 1
      cart.save_to_csv
    end
    if @actions[:save_to_json] == 1
      cart.save_to_json  # Ensure you have this method implemented if you want to handle JSON saving
    end
    if @actions[:save_to_yaml] == 1
      cart.save_to_yaml
    end
  end
end
