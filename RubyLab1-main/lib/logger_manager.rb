require 'logger'  # Add this to load the Logger class

class LoggerManager
  # This method does not need any arguments
  def self.init_logger
    @logger = Logger.new(STDOUT)  # Initializes the logger
    @logger.level = Logger::INFO  # Set the log level (you can adjust this)
  end

  def self.log_processed_file(message)
    @logger.info(message)
  end
end
