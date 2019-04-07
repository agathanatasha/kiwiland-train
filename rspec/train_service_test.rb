require '../train_service'
describe 'trains' do
    NO_SUCH_ROUTE = 'NO SUCH ROUTE'

    context 'get route distance' do
        it 'returns NO SUCH ROUTE when only partial route exists' do
            route = "AED"
            expect(Train_Service.get_distance(route)).to eq(NO_SUCH_ROUTE)
        end

        it 'returns NO SUCH ROUTE when none of the routes exists' do
            route = "ED"
            expect(Train_Service.get_distance(route)).to eq(NO_SUCH_ROUTE)
        end

        it 'returns the distance of the route with one stop route if the route exists' do
            route = "AD"
            expect(Train_Service.get_distance(route)).to eq(5)
        end

        it 'returns the sum of distance for a two-stop route if route exists' do
            route = "ABC"
            expect(Train_Service.get_distance(route)).to eq(9)
        end

        it 'returns the sum of distance for multiple-stop route if route exists' do
            route = "AEBCD"
            expect(Train_Service.get_distance(route)).to eq(22)
        end
    end

    context 'get number of possible paths between two towns' do
        it 'returns number of paths available between two towns with max 1 stop' do
            expect(Train_Service.get_possible_paths_count("A", "C", 1)).to eq(0)
        end
    end
    
end