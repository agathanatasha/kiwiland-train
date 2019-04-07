class Train_Service
    NO_SUCH_ROUTE = "NO SUCH ROUTE"
    GRAPH = ['AB5', 'BC4', 'CD8', 'DC8', 'DE6', 'AD5', 'CE2', 'EB3', 'AE7']

    def self.get_distance route, graph=GRAPH
        total_distance = 0
        for i in 0...route.length-1
            journey = route[i] + route[i+1]
            journey_distance = 0
            for edge in graph
                if edge.start_with? journey
                    journey_distance = edge[-1].to_i
                    total_distance += journey_distance
                end
            end
            return NO_SUCH_ROUTE if journey_distance == 0
        end
        return total_distance
    end

    def self.get_possible_paths_count origin, destination, max_stops, graph=GRAPH
        
    end
end