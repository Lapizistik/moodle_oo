require 'net/http'
require 'json'

require_relative 'category'
require_relative 'course'
require_relative 'user'
require_relative 'client/user'


require_relative 'error'

module MoodleOO
  class Client
    # nil or :terse or :full
    attr_accessor :debug
    
    def initialize(token:, url:, path: PATH)
      @uri = URI.join(url, path)
      @token = token
      @debug = nil
      
      
      @objects = [Category, Course, User].map { |klass|
        [klass, klass.keys.map { |k| [k,{}] }.to_h]
      }.to_h
    end
    
    def site_info
      post('core_webservice_get_site_info')
    end
    
    def course!(id)
      if c = @objects[Course][id]
        c.update!
      else
        Course.new(get_course, self)
      end
    end
    
    def course(id)
      @objects[User][id] || user!(id)
    end
    
    def get_course(id)
      post('core_course_get_courses', options: { ids: [id] }).first
    end
    
    # :nodoc:
    
    def cache(obj)
      obj.class.keys.each do |key|
        @objects[obj.type][key][obj[key]] = obj
      end
    end
    
    def post(function, **params)
      log_request(function, **params)
      parse_response(Net::HTTP.post_form(@uri,
                                         {
                                           wstoken: @token,
                                           moodlewsrestformat: 'json',
                                           wsfunction: function
                                         }.merge(flatten_params(params))))
    end

    def flatten_params(params)
#      puts "processing “#{params.inspect}”"
      params.inject({}) do |h,(k,v)|
        h.merge(kjoin(k,v))
      end
    end

    def kva(**params)
      h = {}
      params.each_with_index do |(k,v),i|
        h[i] = { key: k, value: v }
      end
      h
    end

    def kjoin(k,v)
#      puts "processing “#{k.inspect}” => “#{v.inspect}”"
      case v
      when Hash
        v.inject({}) { |h, (vk, vv)|
          h.merge(kjoin("#{k}[#{vk}]",vv))
        }
      when Array
        v.each_with_index.inject({}) { |h,(vv,i)|
          h.merge(kjoin("#{k}[#{i}]",vv))
        }
      else
        { k => v }
      end
    end
      
    def parse_response(response)
      raise MoodleHTTPError.new(response) unless response.kind_of? Net::HTTPSuccess
      body = JSON(response.body)
      # Moodle returns all kinds of data structures.
      # On error we get an error object (i.e. hashmap):
      raise MoodleServerError.new(response) if body.kind_of?(Hash) && body['errorcode']
      body
    end
  
    
    private
    def log_request(function, **params)
      case @debug
      when :full
        warn ""
      when :terse
        warn ""
      end
    end

    def id_of(obj)
      obj.respond_to?(:id) ? obj.id : obj
    end
  end
end
