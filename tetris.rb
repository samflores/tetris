# frozen_string_literal: true

require 'gosu'
require_relative 'blocks'
require_relative 'grid'

class Game < Gosu::Window
  GRID_SIZE = [10, 20].freeze
  WINDOW_SIZE = [1024, 768].freeze

  CTRL_ROT_RIGHT = 0b0000_0001
  CTRL_ROT_LEFT  = 0b0000_0010
  CTRL_MOV_RIGHT = 0b0000_0100
  CTRL_MOV_LEFT  = 0b0000_1000

  def initialize
    super(*WINDOW_SIZE)
    self.caption = 'Tetris'

    @grid = Grid.new(
      win_width: WINDOW_SIZE[0],
      win_height: WINDOW_SIZE[1], 
      columns: GRID_SIZE[0], 
      rows: GRID_SIZE[1]
    )
    @block = Block.random
    @next_block = Block.random
    @controls = 0
    @tick = 20
    @score = 0
    @font = Gosu::Font.new(20)
  end

  def button_up(key)
    @controls |= case key
                 when Gosu::KB_RIGHT then CTRL_MOV_RIGHT
                 when Gosu::KB_LEFT then CTRL_MOV_LEFT
                 when Gosu::KB_A then CTRL_ROT_LEFT
                 when Gosu::KB_D then CTRL_ROT_RIGHT
                 else 0
                 end
  end

  def draw
    @grid.draw
    @grid.draw_block(@block)
    @font.draw_text("Score: #{@score}", 10, 10, 0)
    @next_block.draw(x_offset: WINDOW_SIZE[0] * 0.7, y_offset: WINDOW_SIZE[1] * 0.25)
  end

  def update
    drop_block
    handle_input
    update_score
    @controls = 0
  end

  private

  def drop_block
    @tick -= 1
    return unless @tick.zero?

    @block.drop
    @tick = 20
  end

  def handle_input
    @block.rotate_right if @controls & CTRL_ROT_RIGHT != 0
    @block.rotate_left if @controls & CTRL_ROT_LEFT != 0
    @block.move_right if @controls & CTRL_MOV_RIGHT != 0
    @block.move_left if @controls & CTRL_MOV_LEFT != 0
  end

  def update_score
    scored = @grid.constrain_block(@block)
    return if scored.nil?

    @score += scored
    @block = @next_block
    @next_block = Block.random
  end
end

game = Game.new
game.show
