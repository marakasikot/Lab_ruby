require_relative './app_config_loader'
require_relative './logger_manager'
require_relative './rental_item'
require_relative './cart'
require_relative './configurator'
require_relative './api_parser'

module DomRiaParserGrigoriakMelenkoMorar
  class Runner
    def self.run
      # Load configurations
      app_config_loader = AppConfigLoader.new
      app_config_loader.load_libs

      config_data = app_config_loader.config('config/default_config.yaml', 'config')
      logging_config = config_data['logging']  # Not used, since LoggerManager doesn't need it here
      webparsing_config = config_data['web_scraping']
      mongodb_config = config_data['mongodb']

      # Initialize Logger without passing config (simplified)
      LoggerManager.init_logger  # Now it doesn't take any arguments

      LoggerManager.log_processed_file("Application started")
