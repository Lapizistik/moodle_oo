require_relative 'mobject'

module MoodleOO

  class Category < MObject
  end

  # # get the category with the given id
  # def category(obj)
  #   Category.fetch(id_of(obj), self)
  # end

  # # get all known categories
  # def categories
  #   @api[Category].index.map { |dict|
  #     Category.create_or_update(dict, self)
  #   }
  # end

end
