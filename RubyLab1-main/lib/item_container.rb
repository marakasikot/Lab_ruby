module ItemContainer
    module ClassMethods
      def class_info
        "Class: #{self.name}, Version: 1.0"
      end
  
      def items_count
        @items_count ||= 0
      end
  
      def increment_items_count
        @items_count = items_count + 1
      end
    end
  
    module InstanceMethods
      def add_item(item)
        items << item
        self.class.increment_items_count
        LoggerManager.log_processed_file("Added item: #{item.info}")
      end
  
      def remove_item(item)
        items.delete(item)
        LoggerManager.log_processed_file("Removed item: #{item.info}")
      end
  
      def delete_items
        items.clear
        LoggerManager.log_processed_file("All items deleted from collection")
      end
  
      def method_missing(method_name, *args)
        if method_name == :show_all_items
          items.each { |item| puts item.info }
        else
          super
        end
      end
  
      def respond_to_missing?(method_name, include_private = false)
        method_name == :show_all_items || super
      end
    end
  
    def self.included(base)
      base.extend(ClassMethods)
      base.include(InstanceMethods)
    end
  end
  