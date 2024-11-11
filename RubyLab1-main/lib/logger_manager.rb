require 'logger'

class LoggerManager
  class << self
    attr_reader :logger

    def init_logger(config)
      log_dir = config['directory']
      log_level = config['level']
      log_files = config['files']

      Dir.mkdir(log_dir) unless Dir.exist?(log_dir)
      @logger = Logger.new(File.join(log_dir, log_files['application_log']))
      @logger.level = Logger.const_get(log_level)
    end

    def log_processed_file(message)
      logger.info(message)
    end

    def log_error(message)
      logger.error(message)
    end
  end
end