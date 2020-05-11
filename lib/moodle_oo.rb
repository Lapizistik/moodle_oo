require 'moodle_rb'
require_relative 'moodle_oo/category'
require_relative 'moodle_oo/course'
require_relative 'moodle_oo/user'

class MoodleOO
  attr_reader :client, :api, :objects
  
  def initialize(token, url, query_options={})
    @client = MoodleRb::Client.new(token, url, query_options)
    @api = {
      Category => @client.categories,
      Course   => @client.courses, 
      User     => @client.users,
    }
    @objects = {
      Category => {},
      Course   => {},
      User     => {},
    }
  end

  def site_info
    @client.site_info
  end
  
  private
  def id_of(obj)
    obj.respond_to?(:id) ? obj.id : obj
  end

end
