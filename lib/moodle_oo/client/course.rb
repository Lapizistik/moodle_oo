
module MoodleOO
  class Client
    
    def course!(id)
      if c = @objects[Course][id]
        c.update!
      elsif dict = get_course(id)        
        Course.new(dict, self)
      else # did not get a course with this id
        # TODO: proper error handling
        nil 
      end
    end

    def course(id)
      @objects[Course][id] || course!(id)
    end
    
    def courses_by_field(field:, value:)
      data = post('core_course_get_courses_by_field',
                  field: field, value: value)
      data['courses'].map { |dict|
        Course.create_or_update(dict, self)
      }
    end

    def get_course(id)
      post('core_course_get_courses', options: { ids: [id] }).first
    end

  end
end
