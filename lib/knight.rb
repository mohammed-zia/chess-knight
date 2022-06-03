class Knight
  attr_reader :position, :icon
  attr_accessor :children, :parent
  MOVES = [[2,1], [2,-1], [1,-2], [-1, -2], [-2, -1], [-2, 1], [-1, 2], [1, 2]].freeze

  def initialize(pos, parent = nil, icon = "\u{265e}")
    @position = pos
    @children = []
    @parent = parent
    @icon = icon
    @R = 8
    @C = 8
  end
  
  def next_moves
    next_moves = []
    MOVES.length.times do |i|
      curr_pos = [@position[0] + MOVES[i][0], @position[1] + MOVES[i][1]]
      unless curr_pos[0] < 0 || curr_pos[1] < 0 || curr_pos[0] >= @R || curr_pos[1] >= @C
        next_moves << curr_pos
      end
    end
    next_moves.delete_if { |move| move.include?(nil) }
    p "NEXT MOVES: #{next_moves}"
    next_moves
  end
end

class Board
  
  attr_accessor :board
  attr_reader :R, :C

  @@board = [ [' ',' ',' ',' ',' ',' ',' ',' '],
              [' ',' ',' ',' ',' ',' ',' ',' '],
              [' ',' ',' ',' ',' ',' ',' ',' '],
              [' ',' ',' ',' ',' ',' ',' ',' '],
              [' ',' ',' ',' ',' ',' ',' ',' '],
              [' ',' ',' ',' ',' ',' ',' ',' '],
              [' ',' ',' ',' ',' ',' ',' ',' '],
              [' ',' ',' ',' ',' ',' ',' ',' '] ]
  @@R, @@C = 8,8
  def initialize
    @board = @@board
    @R = @@R
    @C = @@C
  end

  def print_board
    puts "\n"
    puts "---------- CHESS BOARD ----------"
    @R.times do |i|
      puts "| #{@board[i][0]} | #{@board[i][1]} | #{@board[i][2]} | #{@board[i][3]} | #{@board[i][4]} | #{@board[i][5]} | #{@board[i][6]} | #{@board[i][7]} | "
      puts "+---+---+---+---+---+---+---+---+"
    end
  end

  def update_board(r, c, val)
    @board[r][c] = val
  end

  def knight_moves(start_pos, end_pos)
    current = make_tree(start_pos, end_pos)
    history = []
    make_history(current, history, start_pos)
    print_knight_moves(history, start_pos, end_pos)
  end

  def make_tree(start_pos, end_pos)
    q = [Knight.new(start_pos)]
    current = q.shift
    until current.position == end_pos
      p "CURRENT #{current.position}"
      current.next_moves.each do |move|
        current.children << knight = Knight.new(move, current)
        q << knight
      end
      current = q.shift
    end
    current
  end

  def make_history(current, history, start)
    until current.position == start
      history << current.position
      current = current.parent
    end
    history << current.position
  end

  def print_knight_moves(history, start, destination)
    puts "You made it in #{history.size - 1} moves!"
    puts "To get from #{start} to #{destination} you must traverse the following path:"
    history.reverse.each { |move| puts move.to_s }
  end
end


k = Knight.new([0,0])
b = Board.new
p k.position
b.print_board
b.update_board(0, 3, k.icon)
b.print_board

b.knight_moves([0,0], [3,3])