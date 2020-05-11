require_relative 'obj_dict'

class MoodleOO

  class Course < ObjDict

    def enrolled_users(update=false)
      if update or !@enrolled_users
        if result = @conn.api[self.class].enrolled_users(id)
          @enrolled_users = result.map { |dict|
            User.create_or_update(dict, @conn)
          }
        end
      end
      @enrolled_users
    end

    def enrolled_users!
      enrolled_users(true)
    end
    
    alias users enrolled_users
    alias users! enrolled_users!

    private def inspect_more
      if @enrolled_users
        " users: […(#{@enrolled_users.length})]"
      else
        ""
      end
    end
  end

  # get the course with the given id
  def course(obj)
    Course.fetch(id_of(obj), self)
  end

  # get all known courses
  def courses
    @api[Course].index.map { |dict|
      Course.create_or_update(dict, self)
    }
  end

  def course_users
    # TODO
  end
  
end
