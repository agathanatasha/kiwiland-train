require_relative '../train_map'

describe 'train map' do
    context 'initialize Train_Map Object' do
        it 'creates empty node list after initialize' do
            map = Train_Map.new
            expect(map.nodes).is_a? Hash
            expect(map.nodes).to be_empty
        end
    end

    context 'add route to map' do
        it 'adds two nodes to @nodes' do
            map = Train_Map.new
            map.add_route "AE7"
            expect(map.nodes.length).to be(2)
            expect(map.nodes['A']).is_a? City
            expect(map.nodes['E']).is_a? City
        end

        it 'route is added to origin node' do
            map = Train_Map.new
            map.add_route "AE7"
            expect(map.nodes['A'].distance_to('E')).to be(7)
        end

        it 'adds correct distance weight if distance is two-digit' do
            map = Train_Map.new
            map.add_route "AE70"
            expect(map.nodes['A'].distance_to('E')).to be(70)
        end

        it 'adds correct distance weight if distance is multiple-digit' do
            map = Train_Map.new
            map.add_route "AE64758"
            expect(map.nodes['A'].distance_to('E')).to be(64758)
        end

        it 'route is not added to destination node' do
            map = Train_Map.new
            map.add_route "AE7"
            expect(map.nodes['E'].distance_to('A')).to be(-1)
        end

        it 'adds node only once if origin node already exists' do
            map = Train_Map.new
            map.add_route "AE7"
            map.add_route "AB2"
            expect(map.nodes.length).to be(3)
        end

        it 'adds node only once if destination node already exists' do
            map = Train_Map.new
            map.add_route "EB7"
            map.add_route "AB2"
            expect(map.nodes.length).to be(3)
        end

        it 'does not add new node if duplicate routes are added' do
            map = Train_Map.new
            map.add_route "AE7"
            map.add_route "AE2"
            expect(map.nodes.length).to be(2)
        end

        it 'updates route in node if duplicate routes are added' do
            map = Train_Map.new
            map.add_route "AE7"
            map.add_route "AE2"
            expect(map.nodes['A'].distance_to('E')).to be(2)
        end
    end

    context 'generate map' do
        context 'generate map from a list of one route' do
            it 'add nodes to @nodes' do 
                map = Train_Map.new
                map.generate_map ["AE2"]
                expect(map.nodes.length).to be(2)
                expect(map.nodes['A']).is_a? City
                expect(map.nodes['E']).is_a? City
            end

            it 'adds the route to origin node' do
                map = Train_Map.new
                map.generate_map ["AE2"]
                expect(map.nodes['A'].distance_to('E')).to be(2)
            end
        end

        context 'generate map from list of multiple routes with non-repeating nodes' do
            it 'adds nodes to @nodes' do
                map = Train_Map.new
                map.generate_map ["AE2", "BC10", "DF1"]
                expect(map.nodes.length).to be(6)
            end

            it 'adds routes to the corresponding nodes' do
                map = Train_Map.new
                map.generate_map ["AE2", "BC10", "DF1"]
                expect(map.nodes['A'].distance_to('E')).to be(2)
                expect(map.nodes['B'].distance_to('C')).to be(10)
                expect(map.nodes['D'].distance_to('F')).to be(1)
            end
        end

        context 'generate map from list of routes with repeating nodes' do
            it 'adds nodes to @nodes' do
                map = Train_Map.new
                map.generate_map ["AB5", "BC4", "CD8", "DC8"]
                expect(map.nodes.length).to be(4)
            end

            it 'adds routes to the corresponding nodes' do
                map = Train_Map.new
                map.generate_map ["AB5", "BC4", "CD8", "DC8"]
                expect(map.nodes['A'].distance_to('B')).to be(5)
                expect(map.nodes['B'].distance_to('C')).to be(4)
                expect(map.nodes['C'].distance_to('D')).to be(8)
                expect(map.nodes['D'].distance_to('C')).to be(8)
            end
        end


    end

    context 'check if node is in the map' do
        map = Train_Map.new
        map.generate_map ["AE2"]
        it 'returns true if node exist' do
            expect(map.exist_city?('A')).to be(true)
        end

        it 'returns false if node does not exist' do
            expect(map.exist_city?('B')).to be(false)
        end
    end
end