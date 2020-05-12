require_relative 'obj_dict'
require_relative 'course'

class MoodleOO

  class User < ObjDict

    def initialize(id, conn, attributes = {})
      super(id, conn, attributes)
      if ec = @attributes.delete('enrolledcourses')
        @enrolled_courses = @conn.courses(ec)
      end
    end

    def update(dict=nil)
      super(dict)
      if ec = @attributes.delete('enrolledcourses')
        @enrolled_courses = @conn.courses(ec)
      end
    end
    
    def enrolled_courses(update=false)
      if update or !@enrolled_courses
        if result = @conn.api[self.class].enrolled_courses(id)
          @enrolled_courses = result.map { |dict|
            dict.delete("enrolledusercount")
            dict.delete("progress")
            dict['categoryid'] = dict.delete("category") # why?
            Course.create_or_update(dict, @conn)
          }
        end
      end
      @enrolled_courses
    end

    def enrolled_courses!
      enrolled_courses(true)
    end
        
    alias courses enrolled_courses
    alias courses! enrolled_courses!

    def last_time
      (t = @attributes['lastaccess']) && Time.at(t)
    end
    def first_time
      (t = @attributes['firstaccess']) && Time.at(t)
    end
    
    private def inspect_more
      if @enrolled_courses
        " courses: […(#{@enrolled_courses.length})]"
      else
        ""
      end
    end
  end
  
  # get the course with the given id
  def user(obj)
    User.fetch(id_of(obj), self)
  end
  
  def users(search_params = {})
    @api[User].search(search_params).map { |dict|
      User.create_or_update(dict, self)
    }
  end
  
end

  
