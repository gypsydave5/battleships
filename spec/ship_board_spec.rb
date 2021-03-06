require 'ship_board'

describe ShipBoard do

	let(:ship_two) {
		double :ship_two,
		length: 2,
		elements: [
				:ship_element_two_one,
				:ship_element__two_two,
			],
			coordinates: [1,1],
			orientation: 1
		}

	let(:ship_five) {
		double :ship_five,
		length: 5,
		elements: [
			:ship_element_one,
			:ship_element_two,
			:ship_element_three,
			:ship_element_four,
			:ship_element_five
		],
		coordinates: [0,2],
		orientation: 1
	}

  let (:ship) {
		double :ship,
		length: 1,
		elements: [:ship_element_one],
		coordinates: [1,1],
		orientation: 1
	}

  let ( :ship_board            )  { ShipBoard.new(2,9) }
  let ( :ship_board_two_by_two )  { ShipBoard.new(2,2) }
  let ( :ship_element              )  { double :ship_element   }
	let ( :two_d_9_length_grid  ) { Array.new(9) { Array.new(9) } }
	let ( :three_d_9_length_grid  )  { Array.new(9) {
																			Array.new(9) {
																				Array.new(9)
																			}
																		}
																	}


	it 'is initialized with n dimensions' do
		ship_board_three = ShipBoard.new(3, 9)
		expect(ship_board_three.grid).to eq three_d_9_length_grid
	end

	it 'knows its dimensions' do
		expect(ShipBoard.new(5,2).dimensions).to eq 5
	end

	it 'can return the value at a cells coordinates in 3D' do
		ship_board_three_d = ShipBoard.new(3,9)
		ship_board_three_d.grid[0][1][2] = "Bob"
		expect(ship_board_three_d.cell([0,1,2])).to eq "Bob"
	end

	it 'can return the value at a cells coordinate in 8D' do
		ship_board_eight_d = ShipBoard.new(8,4)
		ship_board_eight_d.grid[1][2][3][3][3][3][3][3] = "Chris"
		expect(ship_board_eight_d.cell([1,2,3,3,3,3,3,3])).to eq "Chris"
	end

	it 'can set the value of cells in 3D' do
		ship_board_three_dee = ShipBoard.new(3,9)
		ship_board_three_dee.set_cell([0,1,2], "Bob")
		expect(ship_board_three_dee.cell([0,1,2])).to eq "Bob"
	end

	it 'can place a ship in the specified coordinates' do
		expect(ship_board.place(ship))
	end

	it 'cannot place a ship in a cell that is already occupied' do
		allow(ship).to receive(:length).and_return(1)
		allow(ship).
			to receive(:elements).
			and_return([:ship_element_one])
		ship_board.place(ship)
		expect{ ship_board.place(ship) }.to raise_error
	end

	it 'cannot place a ship outside the boundaries of the ship board' do
		expect{ ship_board_two_by_two.place(ship_two) }
			.to raise_error(PlacementError)
	end

	it 'cannot place a 1x2 ship horizontally in the top-right corner of a 9x9 board' do
		allow(ship).to receive(:length).and_return(2)
		allow(ship).
			to receive(:elements).
			and_return([:ship_element_one, :ship_element_two])
		allow(ship).to receive(:coordinates).and_return([8,0])
		allow(ship).to receive(:orientation).and_return(0)

		expect{ ship_board.place(ship)}
			.to raise_error(PlacementError)
	end

	it 'cannot place a 1x5 ship horizontally in square 0,7 of a 9x9 board' do
		allow(ship_five).to receive(:coordinates).and_return([7,0])
		allow(ship_five).to receive(:orientation).and_return(0)
		expect{ ship_board.place(ship_five) }
			.to raise_error(PlacementError)
	end

	it 'tells a ship element at a coordinate that it has been hit' do
		allow(ship).to receive(:length).and_return(1)
		allow(ship).to receive(:elements).and_return([ship_element])
		ship_board.place(ship)
		expect(ship_element).to receive(:hit!).and_return(true)
		ship_board.hit_at?([1,1])
	end

	it 'returns false when there is no ship element at the coordinate being fired at' do
		expect(ship_board.hit_at?( [3,3] )).to be false
	end

	it 'places ship elements in the expected board location' do
		allow(ship).to receive(:length).and_return(2)
		allow(ship).to receive(:orientation).and_return(0)
		allow(ship).
			to receive(:elements).
			and_return([:ship_element_one, :ship_element_two])
		ship_board.place(ship)
		expect(ship_board.cell([0,1])).to be nil
		expect(ship_board.cell([1,1])).to be :ship_element_one
		expect(ship_board.cell([2,1])).to be :ship_element_two
	end

	it 'cannot place a ship over another ship element vertically' do
		allow(ship_five).to receive(:coordinates).and_return([0, 1])
		allow(ship_five).to receive(:orientation).and_return(0)
		ship_board.place(ship_five)
		expect{ ship_board.place(ship_two) }.to raise_error
	end

	it 'cannot place a ship over another ship element horizontally' do
		allow(ship_five).to receive(:coordinates).and_return([2, 0])
		ship_board.place(ship_five)
		allow(ship_two).to receive(:orientation).and_return(0)
		expect{ ship_board.place(ship_two) }.to raise_error
	end

	it 'will allow ships to be placed touching' do
		allow(ship_five).to receive(:coordinates).and_return([2, 0])
		ship_board.place(ship_five)
		allow(ship_two).to receive(:coordinates).and_return([2, 5])
		allow(ship_two).to receive(:orientation).and_return(0)
		expect( ship_board.place(ship_two))
	end

end