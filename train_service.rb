require_relative 'train_map'

class Train_Service
    NO_SUCH_ROUTE = "NO SUCH ROUTE"

    def initialize routes
        @map = Train_Map.new
        @map.generate_map(routes)
    end
    attr_reader:map

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

    def all_direct_paths start, destination
        stack = [[start, start]]
        paths = []
        while !stack.empty?
            vertex, path = stack.pop
            for child in @map.nodes[vertex].available_routes.keys
                if !path[1..-1].include? child
                    cur_path = path + child
                    if child == destination
                        paths << cur_path
                    else
                        stack << [child, cur_path]
                    end
                end
            end
        end
        return paths
    end

    def all_direct_paths_count start, destination
        return all_direct_paths(start, destination).length
    end

    def shortest_distance start, destination
        paths = all_direct_paths(start, destination)
        distances = paths.map { |path| get_distance(path) }
        return distances.min
    end

    def filter_paths cur_value, relation, threshold
        case relation
        when '=='
            return cur_value == threshold
        when "<="
            return cur_value <= threshold
        when "<"
            return cur_value < threshold
        else
            raise ArgumentError, "Relation '#{relation}' is not recognized. Only support ==, <=, <."
        end
    end

    def paths_with_stops start, destination, relation, stops_num
        stack = [[start, start]]
        paths = []
        while !stack.empty?
            vertex, path = stack.pop
            if path.length <= stops_num
                for child in @map.nodes[vertex].available_routes.keys
                    cur_path = path + child
                    cur_stop_num = cur_path.length-1
                    if (child == destination && (filter_paths(cur_stop_num, relation, stops_num)))
                        paths << cur_path
                    end
                    stack << [child, cur_path]
                end
            end
        end
        return paths
    end

    def paths_with_stops_count start, destination, relation, stops_num
        return paths_with_stops(start, destination, relation, stops_num).length
    end

    def paths_with_distance start, destination, relation, distance
        stack = [[start, start]]
        paths = []
        while !stack.empty?
            vertex, path = stack.pop
            if get_distance(path) < distance
                for child in @map.nodes[vertex].available_routes.keys
                    cur_path = path + child
                    cur_path_distance = get_distance(cur_path)
                    if ((child == destination) && (filter_paths(cur_path_distance, relation, distance)))
                        paths << cur_path
                    end
                    stack << [child, cur_path]
                end
            end
        end
        return paths
    end

    def paths_with_distance_count start, destination, relation, distance
        return paths_with_distance(start, destination, relation, distance).length
    end
end