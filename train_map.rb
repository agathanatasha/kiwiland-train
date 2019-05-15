require_relative 'city'
class Train_Map
    # node list of City Object as a set (cannot duplicate)
    def initialize
        @nodes = {}
    end
    attr_reader:nodes

    def generate_map routes
        # routes: List of String
        for route in routes
            add_route route
        end
    end

    def add_route route
        # route is a string, first two characters are nodes names, followed by distance
        origin_city_name = route[0]
        destination_city_name = route[1]
        distance = route[2..-1].to_i

        if @nodes.has_key? origin_city_name
            origin_city = @nodes[origin_city_name]
        else
            origin_city = City.new(origin_city_name)
            @nodes[origin_city_name] = origin_city
        end
        origin_city.add_available_route(destination_city_name, distance)

        if @nodes.has_key? destination_city_name
            destination_city = @nodes[destination_city_name]
        else
            destination_city = City.new(destination_city_name)
            @nodes[destination_city_name] = destination_city
        end
    end
end