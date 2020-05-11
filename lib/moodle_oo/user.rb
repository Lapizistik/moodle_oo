require_relative 'obj_dict'

class MoodleOO

  class User < ObjDict
    
    def enrolled_courses(update=false)
      if update or !@enrolled_courses
        if result = @conn.api[self.class].enrolled_courses(id)
          @enrolled_courses = result.map { |dict|
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

  
