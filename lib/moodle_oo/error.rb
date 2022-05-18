require 'json'

module MoodleOO

  # TODO some useful accessors
  
  class MoodleError < StandardError
    attr_reader :response, :function, :params
    def initialize(response, function:, params: nil)
      @response = response
      @function = function
      @params = params
    end    
  end
  
  class MoodleServerError < MoodleError
    def message
      JSON(@response.body)['message']
    end

    def errorcode
      JSON(@response.body)['errorcode']
    end
  end

  class MoodleHTTPError < MoodleError
    def message
      @response.message
    end
    def errorcode
      @response.code
    end
  end
  
end
