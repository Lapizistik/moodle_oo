require_relative 'obj_dict'

class MoodleOO

  class Category < ObjDict
  end

  # get the category with the given id
  def category(obj)
    Category.fetch(id_of(obj), self)
  end

  # get all known categories
  def categories
    @conn.api[Category].index.map { |dict|
      Category.create_or_update(dict, self)
    }
  end

end
