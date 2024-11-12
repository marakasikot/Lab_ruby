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
        @db.execute("INSERT INTO rental_items (vin_1_10, country, city, state, postal) VALUES (?, ?, ?, ?, ?)",
                    [item.vin_1_10, item.country, item.city, item.state, item.postal])
      elsif @db.is_a?(Mongo::Client)
        collection = @db[:rental_items]  
        collection.insert_one(item.to_h) 
      end
    end
    
  
