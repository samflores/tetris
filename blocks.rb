# frozen_string_literal: true

class Block
  SIZE = 30

  def self.random
    @descendants ||= ObjectSpace.each_object(Class).select { |klass| klass < self }
    @descendants.sample.new
  end

  def initialize(pieces, color: :grey)
    @pieces = pieces
    @column = 4
    @row = 0
    @color = color
    @img = Gosu::Image.new("media/#{color}.png").freeze
  end

  attr_reader :color

  def find_piece
    @pieces.find do |(j, i)|
      yield [@column + i, @row + j]
    end
  end

  def each_piece
    @pieces.each do |(j, i)|
      yield [@column + i, @row + j]
    end
  end

  def draw(x_offset: 0, y_offset: 0)
    @pieces.each do |(j, i)|
      @img.draw(x_offset + (i + @column) * SIZE, y_offset + (j + @row) * SIZE, 0)
    end
  end

  def move_right
    @column += 1
  end

  def move_left
    @column -= 1
  end

  def drop
    @row += 1
  end

  def move_up
    @row -= 1
  end

  def rotate_left
    @pieces.map! { |(j, i)| [i, -j] }
  end

  def rotate_right
    @pieces.map! { |(j, i)| [-i, j] }
  end

  def check_boundaries(width, height)
    min_i, max_i, min_j, max_j = boundaries

    @column = min_i.abs if (@column + min_i).negative?
    @row = min_j.abs if (@row + min_j).negative?

    @column = width - max_i.abs - 1 if @column + max_i >= width
    @row = height - max_j.abs - 1 if @row + max_j > height
  end

  private

  def boundaries
    min_j = min_i = 3
    max_j = max_i = -3
    @pieces.each do |(j, i)|
      min_i = i if i < min_i
      max_i = i if i > max_i
      min_j = j if j < min_j
      max_j = j if j > max_j
    end
    [min_i, max_i, min_j, max_j]
  end
end

class O < Block
  def initialize
    super [[0, 0], [1, 0], [0, 1], [1, 1]], color: :green
  end
end

class I < Block
  def initialize
    super [[-2, 0], [-1, 0], [0, 0], [1, 0]], color: :blue
  end
end

class T < Block
  def initialize
    super [[0, -1], [-1, 0], [0, 0], [1, 0]], color: :red
  end
end

class S < Block
  def initialize
    super [[0, 0], [1, 0], [-1, 1], [0, 1]], color: :yellow
  end
end

class Z < Block
  def initialize
    super [[-1, 0], [0, 0], [0, 1], [1, 1]], color: :magenta
  end
end

class J < Block
  def initialize
    super [[-1, 0], [0, 0], [1, 0], [1, 1]], color: :orange
  end
end

class L < Block
  def initialize
    super [[-1, 0], [0, 0], [1, 0], [-1, 1]], color: :cyan
  end
end
