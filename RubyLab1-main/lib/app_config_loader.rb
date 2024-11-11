require 'yaml'
require 'erb'
require 'json'

class AppConfigLoader
  def load_libs
    required_libs = ['date', 'json']
    required_libs.each { |lib| require lib }

    Dir.glob(File.join(__dir__, '*.rb')).each do |file|
      require_relative file unless $LOADED_FEATURES.include?(file)
    end
  end

  def config(file_path, dir)
    @config_data = load_default_config(file_path)
    load_config(dir)
    yield(@config_data) if block_given?
    @config_data['default'] 
  end

  def pretty_print_config_data
    puts JSON.pretty_generate(@config_data)
  end

  private

  def load_default_config(file_path)
    config = YAML.load(ERB.new(File.read(file_path)).result)
    config['default']
  end

  def load_config(dir)
    Dir.glob("#{dir}/*.yaml").each do |file|
      next if file == 'default_config.yaml' 

      config_data = YAML.load(File.read(file))
      @config_data.merge!(config_data) { |key, old_val, new_val| old_val.merge(new_val) }
    end
  end
end
