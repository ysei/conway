require_relative 'life'

describe Cell, "#step" do
  
  # Rule 1
  it "should die if it has fewer than 2 live neighbors" do
    cell = Cell.new(:alive)
    cell.update_live_neighbors_to 0
    cell.step
    
    expect(cell.alive?).to eq(false)
    
    cell = Cell.new(:alive)
    cell.update_live_neighbors_to 1
    cell.step
    
    expect(cell.alive?).to eq(false)
  end
  
  # Rule 2
  it "should continue living if it has 2 or 3 live neighbors" do
    cell = Cell.new(:alive)
    cell.update_live_neighbors_to 2
    cell.step
    
    expect(cell.alive?).to eq(true)
    
    cell = Cell.new(:alive)
    cell.update_live_neighbors_to 3
    cell.step
    
    expect(cell.alive?).to eq(true)
  end
  
  # Rule 3
  it "should die if it has more than 3 live neighbors" do
    (4..8).each do |n|
      cell = Cell.new(:alive)
      cell.update_live_neighbors_to n
      cell.step
      
      expect(cell.alive?).to eq(false)
    end
  end
  
  # Rule 4
  it "should become alive if if has exactly 3 live neighbors" do
    cell = Cell.new(:dead)
    cell.update_live_neighbors_to 3
    cell.step
    
    expect(cell.alive?).to eq(true)
  end
end

describe Cell, "#update_live_neighbors_to" do
  it "should raise an exception if told there are more than 8 live neighbors" do
    cell = Cell.new(:dead)
    expect { cell.update_live_neighbors_to 9 }.to raise_error(ArgumentError)
  end
end

describe Matrix, "#[]" do
  it "should return nil if given negative indices" do
    matrix = Matrix.build(10, 10){ |r, c| rand }
    expect(matrix[0, -1]).to eq(nil)
    expect(matrix[-4, 0]).to eq(nil)
    expect(matrix[-1, -7]).to eq(nil)
  end
end

describe GameOfLife do
  it "should generate a field of cells given a height and width" do
    game = GameOfLife.new(10, 10)
    expect(game.field.count).to eq(100)
  end
  
  it "should have cells that are alive if probability is greater than zero" do
    game = GameOfLife.new(10, 10)
    expect(game.field.any?{ |cell| cell.alive? }).to eq(true)
    
    game = GameOfLife.new(10, 10, 0)    
    expect(game.field.any?{ |cell| cell.alive? }).to eq(false)
  end
end