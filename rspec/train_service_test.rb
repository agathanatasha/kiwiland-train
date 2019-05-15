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

    context 'get all direct paths between two towns' do
        it 'returns empty array when no paths are available' do
            routing_service = Train_Service.new ["AE2", "BC3", "DA8"]
            expect(routing_service.all_direct_paths("A", "C")).to eq([])
        end

        context 'returns array of 1 when only one path is available' do
            routing_service = Train_Service.new ["AX2", "BC3", "CE8", "AC4"]

            it 'returns path with more than one stop' do
                expect(routing_service.all_direct_paths("A", "E")).to eq(["ACE"])
            end

            it 'returns path with only stop' do
                expect(routing_service.all_direct_paths("A", "C")).to eq(["AC"])
            end
        end

        it 'returns correct list of paths when multiple paths exists' do
            routing_service = Train_Service.new ["AE2", "BC3", "CE8", "AC4"]
            expect(routing_service.all_direct_paths("A", "E")).to eq(["AE","ACE"])
        end

        it 'returns correct list of paths when origin and destination are the same' do
            routing_service = Train_Service.new ["AE2", "EB2", "DA13", "EA6", "AB9", "BC7", "BA1"]
            paths = routing_service.all_direct_paths("A", "A").sort
            expected_paths = ["AEBA","AEA", "ABA"].sort
            expect(paths).to eq(expected_paths)
        end

        it 'returns correct paths with cyclic graph' do
            routing_service = Train_Service.new ["AB2", "BC3", "CB5", "CD9"]
            expect(routing_service.all_direct_paths("A", "D")).to eq(["ABCD"])
        end
    end

    context 'get shortest distance between two towns' do
    end

    context 'filter path helper function' do
        service = Train_Service.new ["AE7"]
        it 'uses == operator' do
            expect(service.filter_paths(10, '==', 10)).to eq(true)
            expect(service.filter_paths(9, '==', 10)).to eq(false)
        end

        it 'uses <= operator' do
            expect(service.filter_paths(10, '<=', 10)).to eq(true)
            expect(service.filter_paths(0, '<=', 10)).to eq(true)
            expect(service.filter_paths(11, '<=', 10)).to eq(false)
        end

        it 'uses < operator' do
            expect(service.filter_paths(8, '<', 10)).to eq(true)
            expect(service.filter_paths(10, '<', 10)).to eq(false)
            expect(service.filter_paths(12, '<', 10)).to eq(false)
        end

        it 'raise error with unrecognized relations' do
            expect{service.filter_paths(10, '>', 10)}.to raise_error(ArgumentError)
            expect{service.filter_paths(10, '>=', 10)}.to raise_error(ArgumentError)
            expect{service.filter_paths(10, 'string', 10)}.to raise_error(ArgumentError)
            expect{service.filter_paths(10, 10, 10)}.to raise_error(ArgumentError)
        end
    end
    
    context 'get all available paths with a number of stops filter' do
        context 'given a maximum number of stops' do
            it 'returns empty array if stops_num = 0' do
                routing_service = Train_Service.new ["AE2", "BC3", "CE8", "AC4"]
                expect(routing_service.paths_with_stops("A","C","<=", 0)).to eq([])
            end

            it 'returns correct path if stops_num = 1' do
                routing_service = Train_Service.new ["AD2", "BC3", "CE8", "AC4"]
                expect(routing_service.paths_with_stops("A","D","<=", 1)).to eq(["AD"])
            end

            it 'returns correct paths if stops_num > 1' do
                routing_service = Train_Service.new ["AD2", "DA3", "CE8","CD1", "AC4"]
                expected_paths = ["AD", "ACD"].sort
                less_or_equal_paths = routing_service.paths_with_stops("A","D","<=", 2).sort
                less_paths = routing_service.paths_with_stops("A","D","<", 3).sort
                expect(less_or_equal_paths).to eq(expected_paths)
                expect(less_paths).to eq(expected_paths)
            end

            it 'returns empty array if no available paths' do
                routing_service = Train_Service.new ["AD2", "BC3", "CE8", "AC4"]
                expect(routing_service.paths_with_stops("B","A","<=", 5)).to eq([])
            end

            it 'returns correct paths if start and destination are the same' do
                routing_service = Train_Service.new ["AD1", "DE5", "EA4", "DA9", "AC19"]
                expect(routing_service.paths_with_stops("A", "A", "<", 3)).to eq(["ADA"])
            end

            it 'returns all correct paths with repeating paths' do
                routing_service = Train_Service.new ["AD2", "DA3", "CE8","CD1", "AC4"]
                paths = routing_service.paths_with_stops("A","A","<=", 5).sort
                expected_paths = ["ACDA", "ACDADA", "ADA", "ADACDA", "ADADA"].sort
                expect(paths).to eq(expected_paths)
            end

        end

        context 'given an exact number of stops' do
            it 'returns empty array if stops_num = 0' do
                service = Train_Service.new ["AE3", "BE2", "AB6"]
                expect(service.paths_with_stops("A", "E", "==", 0)).to eq([])
            end

            it 'returns correct path if stops_num = 1' do
                service = Train_Service.new ["AE3", "BE2", "AB6"]
                expect(service.paths_with_stops("A", "E", "==", 1)).to eq(["AE"])
            end

            it 'returns correct paths if stops_num > 2' do
                service = Train_Service.new ["AE3", "BE2", "AB6"]
                expect(service.paths_with_stops("A", "E", "==", 2)).to eq(["ABE"])
            end

            it 'returns empty array if no available paths' do
                service = Train_Service.new ["AE3", "BE2", "AB6", "CF1"]
                expect(service.paths_with_stops("A", "F", "==", 5)).to eq([])
            end

            it 'returns correct paths if start and destination are the same' do
                service = Train_Service.new ["AE3", "BE2", "AB6", "CF1", "EB9", "BA4"]
                expect(service.paths_with_stops("A", "A", "==", 4)).to eq(["ABABA", "ABEBA"])
            end
        end

        it 'returns correct paths with cyclic graph' do
            routing_service = Train_Service.new ["AB2", "BC3", "CB5", "CD9"]
            expect(routing_service.paths_with_stops("A", "D", "==", 3)).to eq(["ABCD"])
        end
    end

    context 'get all available paths with a distance filter' do
        it 'returns empty array if distance = 0' do
            service = Train_Service.new ["AE3", "BE2", "AB6", "CF1", "EB9", "BA4"]
            expect(service.paths_with_distance("A", "A", "<=", 0)).to eq([])
        end

        it 'returns correct paths if distance != 0' do
            service = Train_Service.new ["AE3", "BE2", "AB6", "CF1", "EB9", "BA4"]
            expect(service.paths_with_distance("A", "A", "<=", 10)).to eq(["ABA"])
        end

        it 'returns empty array if no available path that fulfills the distance filter' do
            routing_service = Train_Service.new ["AB2", "BC3", "CD9"]
            expect(routing_service.paths_with_distance("A", "D", "<", 10)).to eq([])
        end

        it 'returns correct paths with cyclic graph' do
            routing_service = Train_Service.new ["AB2", "BC3", "CB5", "CD9"]
            expect(routing_service.paths_with_distance("A", "D", "<=", 20)).to eq(["ABCD"])
        end
    end
end

describe 'provided test inputs' do
    service = Train_Service.new GRAPH
    it 'returns distance of route A-B-C' do
        expect(service.get_distance("ABC")).to eq(9)
    end

    it 'returns distance of route A-D' do
        expect(service.get_distance("AD")).to eq(5)
    end

    it 'returns distance of route A-D-C' do
        expect(service.get_distance("ADC")).to eq(13)
    end

    it 'returns distance of route A-E-B-C-D' do
        expect(service.get_distance("AEBCD")).to eq(22)
    end

    it 'returns distance of route A-E-D' do
        expect(service.get_distance("AED")).to eq(NO_SUCH_ROUTE)
    end

    it 'returns number of trips starting at C and ending at C with a maximum of 3 stops' do
        paths = service.paths_with_stops("C", "C", "<=", 3).sort
        expected_paths = ["CDC", "CEBC"].sort
        expect(paths).to eq(expected_paths)
        expect(service.paths_with_stops_count("C", "C", "<=", 3)).to eq(2)
    end

    it 'returns number of trips starting at A and ending at C with exactly 4 stops' do
        paths = service.paths_with_stops("A", "C", "==", 4).sort
        expected_paths =["ABCDC", "ADCDC", "ADEBC"]
        expect(paths).to eq(expected_paths)
        expect(service.paths_with_stops_count("A", "C", "==", 4)).to eq(3)
    end

    it 'length of the shortest route in terms of distance from A to C' do
        expect(service.shortest_distance("A", "C")).to eq(9)
    end

    it 'length of the shortest route in terms of distance from B to B' do
        expect(service.shortest_distance("B", "B")).to eq(9)
    end

    it 'number of different routes from C to C with a distance of less than 30' do
        paths = service.paths_with_distance("C", "C", "<", 30).sort
        expected_paths = ["CDC", "CEBC", "CEBCDC", "CDCEBC", "CDEBC",
             "CEBCEBC", "CEBCEBCEBC"].sort
        expect(paths).to eq(expected_paths)
        expect(service.paths_with_distance_count("C", "C", "<", 30)).to eq(7)
    end
end