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
    attr_reader :debug

    # OpenSSL::SSL::VERIFY_NONE
    # OpenSSL::SSL::VERIFY_PEER
    def initialize(token:, url:, path: PATH, ssl_verify_mode: OpenSSL::SSL::VERIFY_PEER)
      @uri = URI.join(url, path)
      @token = token
      @debug = nil
      @ssl_verify_mode = ssl_verify_mode
      
      
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
      @objects[Course][id] || course!(id)
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

    def post_raw(function, **params)
      Net::HTTP.Proxy('localhost',5555).post_form(@uri,
                          {
                            wstoken: @token,
                            moodlewsrestformat: 'json',
                            wsfunction: function
                          }.merge(flatten_params(params)))
    end
    
    def post_simple(function, **params)
      log_request(function, **params)
      parse_response(Net::HTTP.post_form(@uri,
                                         {
                                           wstoken: @token,
                                           moodlewsrestformat: 'json',
                                           wsfunction: function
                                         }.merge(flatten_params(params))),
                     function: function, params: params)
    end

    def post_fc(function, **params)
      log_request(function, **params)
      response = Net::HTTP.start(@uri.host, @uri.port,
                                 use_ssl: true,
                                 verify_mode: @ssl_verify_mode) do |http|
        http.read_timeout = 60*30
        request = Net::HTTP::Post.new(@uri.path)
        request["Content-Type"] = "application/json"
        request.set_form_data({
          wstoken: @token,
          moodlewsrestformat: 'json',
          wsfunction: function
        }.merge(flatten_params(params)))

        http.request(request) # Net::HTTPResponse object
      end
      parse_response(response, function: function, params: params)
    end

    alias post post_fc

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
      
    def parse_response(response, function:, params:)
      raise MoodleHTTPError.new(response, function: function, params: params) unless response.kind_of? Net::HTTPSuccess
      body = JSON(response.body)
      # Moodle returns all kinds of data structures.
      # On error we get an error object (i.e. hashmap):
      raise MoodleServerError.new(response, function: function, params: params) if body.kind_of?(Hash) && body['errorcode']
      body
    end
  
    def debug=(type)
      @debug = type
      case @debug
      when :full
        require 'pp'
      when true
        @debug = :terse
      end
      @debug
    end

    private
    def log_request(function, **params)
      case @debug
      when :full
        warn "POST #{@uri}: #{function}"
        PP.pp(params, $stderr)
      when :terse
        warn "POST #{@uri}: #{function}"
      end
    end

    def id_of(obj)
      obj.respond_to?(:id) ? obj.id : obj
    end
  end
end
