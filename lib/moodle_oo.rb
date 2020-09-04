require_relative 'moodle_oo/client'

module MoodleOO 
  PATH='/webservice/rest/server.php'

  def self.connect(**params)
    Client.new(**params)
  end

end
