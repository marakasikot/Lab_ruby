require 'mongo'
require 'sqlite3'
class DatabaseConnector
    attr_reader :db
  
    def initialize(config)
      @config = config
      @db = nil
    end
  
    def connect_to_database
      case @config['database_type']
      when 'sqlite'
        connect_to_sqlite
      when 'mongodb'
        connect_to_mongodb
      else
        raise "Unsupported database type: #{@config['database_type']}"
      end
    end
  
    def close_connection
      if @db.is_a?(SQLite3::Database)
        @db.close if @db
      elsif @db.is_a?(Mongo::Client)
        @db.close
      end
    end
  
    def save_rental_item(item)
      if @db.is_a?(SQLite3::Database)
        @db.execute("INSERT INTO rental_items (price, address, square_meters, rooms, image_path) VALUES (?, ?, ?, ?, ?)",
                    [item.price, item.address, item.square_meters, item.rooms, item.image_path])
      elsif @db.is_a?(Mongo::Client)
        collection = @db[:rental_items]  
        collection.insert_one(item.to_h) 
      end
    end
    
  
    private
  
    def connect_to_sqlite
      @db = SQLite3::Database.new(@config['sqlite_database']['db_file'])
      @db.timeout = @config['sqlite_database']['timeout']
    end
  
    def connect_to_mongodb
      options = {
    database:@config['mongodb_database']['db_name'],  
  }

      @db = Mongo::Client.new(@config['mongodb_database']['uri'],options)
    end
  end
  