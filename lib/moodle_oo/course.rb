# coding: utf-8
require_relative 'mobject'
#require_relative 'course_user'

module MoodleOO

  class Course < MObject

  #   def enrolled_users(update=false)
  #     if update or !@enrolled_users
  #       if result = @conn.api[self.class].enrolled_users(id)
  #         @enrolled_users = result.map { |dict|
  #           CourseUser.new(self, dict)
  #         }
  #       end
  #     end
  #     @enrolled_users
  #   end
    
  #   def enrolled_users!
  #     enrolled_users(true)
  #   end

  #   # @param users list of users (or user_ids) to enrol
  #   # @param role_id role for these
  #   # @param params optional parameters: timestart, timeend, suspend
  #   def enrol_users(users, role_id, **params)
  #     @conn.client.post('enrol_manual_enrol_users',
  #                       enrolments: users.map.with_index {|u,i|
  #                         [i, {
  #                           userid: id_of(u),
  #                           roleid: role_id
  #                         }.merge(params)]
  #                       }.to_h
  #                      )
                            
  #   end
    
  #   alias users enrolled_users
  #   alias users! enrolled_users!

  #   private def inspect_more
  #     if @enrolled_users
  #       " users: […(#{@enrolled_users.length})]"
  #     else
  #       ""
  #     end
  #   end

    class << self
      def keys
        [:id, :idnumber, :username, :email]
      end
    end
  end

  # # @param courses a list of hashmaps with course parameters
  # # e.g. #create_courses([{fullname: 'Course Name', shortname: 'Cname',
  # #                        categoryid: 23, …}, {…}, …])
  # # fullname, shortname and categoryid are required, all others optional
  # def create_courses(courses)
  #   @client.post(
  #     'core_course_create_courses',
  #     courses: courses.map.with_index { |c,i| [i,c] }.to_h
  #   )
  # end


  # # get the course with the given id
  # def course(obj)
  #   Course.fetch(id_of(obj), self)
  # end

  # def courses_by_field(key, val)
  #   list = @client.post('core_course_get_courses_by_field',
  #                       field: key, value: val).last
  #   list.map { |dict|
  #     Course.create_or_update(dict, self)
  #   } 
  # end
  
  # # get all known courses
  # def courses(list=@api[Course].index)
  #   list.map { |dict|
  #     Course.create_or_update(dict, self)
  #   }
  # end

  # def course_users
  #   # TODO
  # end 
end
