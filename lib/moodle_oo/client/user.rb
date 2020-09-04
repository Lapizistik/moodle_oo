
module MoodleOO
  class Client
    
    def user!(id)
      if u = @objects[User][:id][id]
        u.update!
      else
        User.new(get_user(id).first, self)
      end
    end

    def user(id)
      @objects[User][:id][id] || User.new(get_user(id), self)
    end
    
    ##
    # @param criteria:
    # id: matching user id
    # lastname: user last name
    # firstname: user first name
    # idnumber: matching user idnumber
    # username: matching user username,
    # email: user email
    # auth: matching user auth plugin
    # For lastname, firstname, email you can use % for searching
    # but it may be considerably slower!
    def get_users_search(**criteria)
      post('core_user_get_users', criteria: kva(**criteria))['users']
    end

    ##
    # @params field: [value, …]
    # field may be: id, idnumber, username, email,
    # only one field may be set!
    def users_by(**param)
      raise 'give exactly one parameter!' unless param.length == 1
      field, values = param.first
      values = [values] unless values.kind_of? Array

      # see which users are not cached
      unknown = values.reject { |v|
        @objects[User][field][v]
      }
      # fetch these users, so they are in the cache
      get_users_by(field: field, values: unknown).map { |dict|
        User.new(dict, self)
      }
      # and now collect all of them
      values.map { |v|
        @objects[User][field][v]
      }
    end

    def get_users_by(field:, values:)
      post('core_user_get_users_by_field', field: field, values: values)
    end

    def get_user(id)
      get_users_by(field: 'id', values: [id]).first
    end
  end
end
