require '../city'
describe 'City' do 
    context 'Initialize city object' do
        it 'return City name after initialize' do
            new_city = City.new('Toronto')
            expect(new_city.name).to eq('Toronto')
        end

        it 'return empty hash after initialize' do
            new_city = City.new('Toronto')
            available_routes = new_city.available_routes
            expect(available_routes).is_a?(Hash)
            expect(available_routes).to be_empty
        end
    end

    context 'Can add available route to City' do
        it 'correct city_name and distance is added to City' do
            city = City.new('Toronto')
            city.add_available_route('Montreal', 10)
            expect(city.available_routes).to eq({'Montreal' => 10})
        end

        it 'should raise with non-string city_name, no route added' do
            city = City.new('Toronto')
            expect{city.add_available_route([1], 10)}.to raise_error(ArgumentError)
            expect(city.available_routes).to be_empty
        end

        it 'should raise with non-integer distance argument, no route added' do
            city = City.new('Toronto')
            expect{city.add_available_route('Montreal', 'QC')}.to raise_error(ArgumentError)
            expect(city.available_routes).to be_empty
        end

        it 'can add multiple routes to City' do
            city = City.new('Toronto')
            city.add_available_route('Montreal', 10)
            city.add_available_route('Kingston', 2)
            city.add_available_route('Ottawa', 5)
            expect(city.available_routes).to eq({'Montreal' => 10, 'Kingston' => 2, 'Ottawa' => 5})
        end

        it 'update existing route if add route to same city twice' do
            city = City.new('Toronto')
            city.add_available_route('Montreal', 10)
            city.add_available_route('Montreal', 15)
            expect(city.available_routes).to eq({'Montreal' => 15})
        end
    end

    context 'distance to another city' do
        it 'returns -1 if no path is available' do
            city = City.new('Toronto')
            city.add_available_route('Montreal', 10)
            expect(city.distance_to('Kingston')).to eq(-1)
        end

        it 'returns distance if path is available' do 
            city = City.new('Toronto')
            city.add_available_route('Montreal', 10)
            expect(city.distance_to('Montreal')).to eq(10)
        end

        it 'returns -1 if available paths is empty' do
            city = City.new('Toronto')
            expect(city.distance_to('Montreal')).to eq(-1)
        end
    end
end