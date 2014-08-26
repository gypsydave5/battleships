require 'placement_grid'

describe PlacementGrid do

	let(:placement_grid) { PlacementGrid.new(2,2) }
	let(:ship)			 { double :ship }
	let(:ship_element)	{ double :ship, :hit!, ship_element}

	it 'is initialized with dimensions' do
		expect(placement_grid).to eq placement_grid
	end

	it 'can place a ship in the specified coordinates' do
		allow(ship).to receive(:elements).and_return([:ship_element_one])
		expect(placement_grid.place(ship,1,1)).to eq placement_grid
	end

	it 'can\'t place a ship in a cell that\'s already occupied' do
		allow(ship).to receive(:elements).and_return([:ship_element_one])
		placement_grid.place(ship,1,1)
		expect{ placement_grid.place(ship,1,1) }.to raise_error
	end

	it 'can\'t place a ship outside the boundaries of the placement grid' do
		allow(ship).to receive(:elements).and_return([:ship_element_one, :ship_element_two, :ship_element_three])
		expect{ placement_grid.place(ship,1,1) }.to raise_error(ArgumentError, "Ship don't fit yo!")
	end

	it 'cannot place a 1x2 ship horizontally in the top-right corner of a 9x9 grid' do
		placement_grid = PlacementGrid.new(9,9)
		allow(ship).to receive(:elements).and_return([:ship_element_one, :ship_element_two])
		expect{ placement_grid.place(ship, 8, 0)}.to raise_error(ArgumentError)
	end

	it 'cannot place a 1x5 ship vertically in square 0,7 of a 9x9 grid' do
		placement_grid = PlacementGrid.new(9,9)
		allow(ship).to receive(:elements).and_return([:ship_element_one, :ship_element_two, :ship_element_three, :ship_element_four, :ship_element_five])
		expect{ placement_grid.place(ship, 0, 7, :vertical)}.to raise_error(ArgumentError)
	end

	xit 'tells a ship element at a coordinate that it has been hit' do
		expect(ship_element).to receive(:hit!).and_return


end