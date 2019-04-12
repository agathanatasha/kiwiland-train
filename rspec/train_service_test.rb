require_relative '../train_service'
describe 'trains' do
    NO_SUCH_ROUTE = 'NO SUCH ROUTE'
    GRAPH = ['AB5', 'BC4', 'CD8', 'DC8', 'DE6', 'AD5', 'CE2', 'EB3', 'AE7']

    context 'get route distance' do
        routing_service = Train_Service.new GRAPH
        it 'returns NO SUCH ROUTE when only partial route exists' do
            route = "AED"
            expect(routing_service.get_distance(route)).to eq(NO_SUCH_ROUTE)
        end

        it 'returns NO SUCH ROUTE when none of the routes exists' do
            route = "ED"
            expect(routing_service.get_distance(route)).to eq(NO_SUCH_ROUTE)
        end

        it 'returns the distance of the route with one stop route if the route exists' do
            route = "AD"
            expect(routing_service.get_distance(route)).to eq(5)
        end

        it 'returns the sum of distance for a two-stop route if route exists' do
            route = "ABC"
            expect(routing_service.get_distance(route)).to eq(9)
        end

        it 'returns the sum of distance for multiple-stop route if route exists' do
            route = "AEBCD"
            expect(routing_service.get_distance(route)).to eq(22)
        end
    end

    context 'get number of possible paths between two towns' do
        it 'returns 0 when max_stop = 0' do
            routing_service = Train_Service.new ["AE2", "BC3", "DA8", "AC4"]
            expect(routing_service.get_possible_paths_count("A", "C", 0)).to eq(0)
        end

        context 'maximum number of stops = 1' do
            it 'returns 0 when no path exists' do
                routing_service = Train_Service.new ["AE2", "BC3", "DA8"]
                expect(routing_service.get_possible_paths_count("A", "C", 1)).to eq(0)
            end

            it 'returns 1 when one path exists' do
                routing_service = Train_Service.new ["AE2", "BC3", "DA8", "AD5"]
                expect(routing_service.get_possible_paths_count("A", "D", 1)).to eq(1)
            end
        end

        context 'maximum number of stops = 2' do
            it 'returns 0 when no paths exist' do
                routing_service = Train_Service.new ["AB5", "AC2", "CD5", "DE2"]
                expect(routing_service.get_possible_paths_count("A", "E", 2)).to eq(0)
            end

            it 'returns 1 when one 1-stop path exist' do
                routing_service = Train_Service.new ["AB5", "AC2", "CD5", "DE2"]
                expect(routing_service.get_possible_paths_count("A", "B", 2)).to eq(1)
            end

            # it 'returns 1 when one 2-stop path exist' do
            #     routing_service = Train_Service.new ["AB5", "BC2", "CD5", "DE2"]
            #     expect(routing_service.get_possible_paths_count("A", "C", 2)).to eq(1)
            # end
        end
        # if origin and destination is the same
    end
    
end