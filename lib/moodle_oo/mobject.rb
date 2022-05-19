module MoodleOO

  private
  class MObject
    attr_reader :id, :client
    def initialize(dict, client)
      @id = dict['id'] or
        raise "ID missing on #{self.class} data:\n#{mobj.inspect}"
      @client = client
      @attributes = dict
      @client.cache(self)
    end

    # merge user attributes from dict.
    def merge(dict)
      dict['id'] == @id or raise "this is not the right dict!"
      @attributes.merge!(dict)
      self
    end

    def update(dict=nil)
      if dict
        dict['id'] == @id or raise "this is not the right dict!"
      else
        dict = @client.api[self.class].show(@id)
      end
      @attributes.merge!(dict)
      self
    end

    def method_missing(key)
      @attributes[key.to_s] 
    end

    def respond_to?(key)
      @attributes.has_key?(key.to_s) || super
    end

    def [](key)
      @attributes[key.to_s]
    end

    def inspect
      "#<#{self.class} " + @attributes.map { |k,v|
        "#{k}=“#{v.to_s.sub(/[\n\r].*/m,'…')}”" }.join(' ') + inspect_more + ">"
    end

    def type
      self.class
    end
    
    private def inspect_more
      ''
    end
    
    class << self
      def create_or_update(dict, conn)
        id = dict['id'] or raise "this is not a valid dict!"
        obj = conn.objects[self][id]
        if obj
          obj.update(dict)
        else
          obj = new(dict, conn)
          conn.objects[self][id] = obj
        end
        obj
      end

#      def fetch(id, conn)
#        if dict = conn.api[self].show(id)
#          create_or_update(dict, conn)
#        else
#          nil
#        end
#      end
    end

    class << self
      def keys
        [:id]
      end
    end
  end
end
