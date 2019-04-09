class City
    # route available: hash {city: weight/distance}
    # init new City, properties: route hash, name
    def initialize name
        # name: String
        # route_hash: {'city_name': distance}
        # distance: integer
        @name = name
        @available_routes = {}
    end
    attr_accessor :name, :available_routes

    def add_available_route city_name, distance
        if city_name.is_a?(String) && distance.is_a?(Integer)
            @available_routes[city_name] = distance
        else
            raise ArgumentError, "Invalid input, city_name should be a string and distance is an integer"
        end
    end

    def distance_to city_name
        # return -1 if no path is available
        # return integer for distance
        if @available_routes.has_key? city_name
            return @available_routes[city_name]
        else
            return -1
        end
    end
end
