# frozen_string_literal: true

class Grid
  IMAGES = %w[blue cyan green grey magenta orange red yellow].each_with_object({}) do |color, acc|
    acc[color.to_sym] = Gosu::Image.new("media/#{color}.png").freeze
  end.freeze

  def initialize(win_height: 768, win_width: 1024, columns: 10, rows: 20)
    @columns = columns
    @rows = rows
    @grid = Array.new(rows) { Array.new(columns, nil) }
    @left = (win_width - Block::SIZE * (@columns + 2)) / 2
    @top = (win_height - Block::SIZE * (@rows + 2)) / 2
  end

  def draw
    draw_border
    draw_planted
  end

  def draw_border
    draw_horizontal_borders
    draw_vertical_borders
  end

  def draw_planted
    @grid.each_with_index do |row, i|
      row.each_with_index do |box, j|
        next unless box

        draw_box(box, j, i)
      end
    end
  end

  def draw_block(block)
    block.draw(x_offset: @left, y_offset: @top)
  end

  def constrain_block(block)
    block.check_boundaries(@columns, @rows)
    return unless block_collided?(block)

    block.move_up
    plant_block(block)
  end

  def block_collided?(block)
    !!block.find_piece { |col, row| row == @rows || @grid[row][col] }
  end

  def plant_block(block)
    block.each_piece { |col, row| @grid[row][col] = block.color }
    check_completed
  end

  def check_completed
    scored = 0
    (1..(@rows - 1)).each do |i|
      if @grid[i].all?
        @grid.delete_at(i)
        @grid.unshift(Array.new(@columns, nil))
        scored += 1
      end
    end
    scored
  end

  private

  def draw_horizontal_borders
    (-1..@columns).each do |col|
      draw_box(:grey, col, -1)
      draw_box(:grey, col, @rows)
    end
  end

  def draw_vertical_borders
    (0..@rows - 1).each do |row|
      draw_box(:grey, -1, row)
      draw_box(:grey, @columns, row)
    end
  end

  def draw_box(image, col, row)
    IMAGES[image].draw(col * Block::SIZE + @left, row * Block::SIZE + @top, 0)
  end
end
