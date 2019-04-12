require_relative 'train_map'

class Train_Service
    NO_SUCH_ROUTE = "NO SUCH ROUTE"
    GRAPH = ['AB5', 'BC4', 'CD8', 'DC8', 'DE6', 'AD5', 'CE2', 'EB3', 'AE7']

    def initialize routes
        @map = Train_Map.new
        @map.generate_map(routes)
    end

    def get_distance route
        total_distance = 0
        for i in 0...route.length-1
            origin_city_name = route[i]
            destination_city_name = route[i+1]
            journey_distance = @map.nodes[origin_city_name].distance_to(destination_city_name)
            return NO_SUCH_ROUTE if journey_distance == -1
            total_distance += journey_distance
        end
        return total_distance
    end

    def get_possible_paths_count origin, destination, max_stops
        possible_paths = []
        if @map.nodes[origin].distance_to(destination) == -1 || max_stops == 0
            return 0
        else
            return 1
        end
    end
end