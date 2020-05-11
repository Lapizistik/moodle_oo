class MoodleOO

  private
  class ObjDict
    attr_reader :id
    def initialize(id, conn, attributes = {})
      @id = id
      @conn = conn
      @attributes = attributes
    end

    def update(dict=nil)
      if dict
        dict['id'] == @id or raise "this is not the right dict!"
      else
        dict = conn.apis[self.class].show(@id)
      end
      @attributes = dict
      self
    end

    def method_missing(key)
      @attributes[key.to_s] 
    end

    def respond_to?(key)
      @attributes.has_key?(key.to_s) || super
    end

    def [](key)
      @attributes[key]
    end

    def inspect
      "#<#{self.class} " + @attributes.map { |k,v|
        "#{k}=“#{v}”" }.join(' ') + inspect_more + ">"
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
          obj = new(id, conn, dict)
          conn.objects[self][id] = obj
        end
        obj
      end

      def fetch(id, conn)
        if dict = conn.api[self].show(id)
          create_or_update(dict, conn)
        else
          nil
        end
      end
    end
  end
end
