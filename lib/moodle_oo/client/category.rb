
module MoodleOO
  class Client
    def create_categories(categories)
      post('core_course_create_categories', categories: categories)
    end

    def get_categories_search(**criteria)
      post('core_course_get_categories', criteria: kva(**criteria))
    end
  end
end
