#!/usr/bin/env ruby 

require 'moodle_rb'

module MoodleRb
  class Client
    # explicit method for debugging
    def get(function, **param)
      self.class.get('/webservice/rest/server.php',
                     {
                       query: query_hash(function, token),
                     }.merge(query_options)
                    )
    end
    # explicit method for debugging
    def post(function, **param)
      response = self.class.post('/webservice/rest/server.php',
                                 {
                                   query: query_hash(function, token),
                                   body: param
                                 }.merge(query_options)
                                )
      check_for_errors(response)
      response.parsed_response.first
    end
  end
end
