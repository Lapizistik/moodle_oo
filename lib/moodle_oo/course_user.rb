require_relative 'user'

class MoodleOO

  # this is a wrapper for user that holds role and group
  # information of a user for a given course
  class CourseUser < SimpleDelegator
    attr_reader :course, :roles, :groups
    def initialize(course, attributes)
      @course = course
      @roles = attributes.delete('roles')
      @groups = attributes.delete('groups')
      super(User.create_or_update(attributes, course.conn))
    end

    def inspect
      "#<#{self.class} " + __getobj__.inspect +
        ' roles=' + @roles.inspect +
        ' groups=' + @groups.inspect + '>' 
    end
  end
  
end
