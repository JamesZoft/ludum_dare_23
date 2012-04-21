#!/usr/bin/env ruby

require 'gosu'
require 'pp'

class GameWindow < Gosu::Window

  attr_reader :tilemap

  def initialize
    super 640, 480, false
    self.caption = "Ludum Dare 23"
    @height = self.height
    @width = self.width
    @image = Gosu::Image.new(self, "sprite_forwards.png", true)
    @world = World.new(self)
    @player = Player.new(self)
    @player.warp(340, 322.5)
    @camera_x = @player.x - @width/2
    @camera_y = @player.y - @height/2
  end

  def draw
    @world.draw(-@camera_x, -@camera_y, @width, @height, @camera_x, @camera_y)
    @image.draw_rot(@player.x - @camera_x, @player.y - @camera_y, 1, 0.0)
  end


  def update
    if button_down? Gosu::KbLeft or button_down? Gosu::KbA then
      puts "in update"
      @player.accelerate_backwards(0.65)
    end
    if button_down? Gosu::KbRight or button_down? Gosu::KbD then
      puts "in update"
      @player.accelerate_forwards(0.65)
    end
    if button_down? Gosu::KbUp or button_down? Gosu::KbW or button_down? Gosu::KbSpace then
      @player.jump
    end
      if button_down? Gosu::KbDown or button_down? Gosu::KbS then
      @player.shrink
    end 
    @player.move
    @camera_x = @player.x - @width/2
    @camera_y = @player.y - @height/2
    #@camera_x = [[@player.x - 320, 0].max, @width * 50 - 640].min
    #@camera_y = [[@player.y - 240, 0].max, @height * 50 - 480].min
  end

  def button_down(id)
    if id == Gosu::KbEscape 
      close
    end
  end
end

class World

  def initialize(window)
    @tileset = Gosu::Image.load_tiles(window, "tileset.png", 32, 32, true)
    @tilemap = Array.new(2000) do |y|
      Array.new(2000) do |x|
        if x <= 100/8
          Tiles::Sky
        else
          Tiles::Grass
        end
      end
    end
  end

  def draw(offset_x, offset_y, max_width, max_height, camera_x, camera_y)
    n = Time.now
    y_start = (camera_y/32).to_i
    y_finish = @tilemap.length
    (y_start..(y_finish - 1)).each do |y|
      if (y * 32) > (max_height + camera_y)
        break
      end
      if (y * 32 + 32) < camera_y
        next
      end
      x_start = (camera_x/32).to_i
      x_finish = @tilemap[0].length
      (x_start..(x_finish - 1)).each do |x|
        if (x * 32) > (max_width + camera_x)
          break
        end
        if (x * 32 + 32) < camera_x
          next
        end
        tile = @tilemap[x][y]
        #puts tile
        if tile
          @tileset[tile].draw(x * 32 + offset_x, y * 32 + offset_y, 0)
        end
      end
    end
    m = Time.now
    x = ((m - n)*1000).to_i
    puts x
    #sleep(0.5)
  end
  
end

class Player
  
  attr_reader :x, :y
  
  def initialize(window)
    @image = Gosu::Image.new(window, "sprite_forwards.png", false)
    @x = @y = @vel_x = @vel_y = @angle = 0.0
    @score = 0
  end

  def warp(x, y)
    @x, @y = x, y
  end

  def turn_left
    @angle -= 4.5
  end

  def turn_right
    @angle += 4.5
  end

	def jump
	end
	
	def shrink
	end

  def accelerate_forwards(acceleration)
  	puts "in accelerate_forwards"
    @vel_x += Gosu::offset_x(@angle + 90, acceleration)
    @vel_y += Gosu::offset_y(@angle + 90, acceleration)
  end
  
  def accelerate_backwards(acceleration)
    @vel_x -= Gosu::offset_x(@angle + 90, acceleration)
    @vel_y -= Gosu::offset_y(@angle + 90, acceleration)
  end

  def move
  	puts "in move"
    @x += @vel_x
    @y += @vel_y
    @x %= 32*2000
    @y %= 32*2000

    @vel_x *= 0.95
    @vel_y *= 0.95
  end
  
  def update
  	accelerate
  	move
  end

  def draw
  	puts "in draw"
    @image.draw_rot(@x, @y, 1, @angle)
  end
end

module Tiles
  Grass = 0
  Sky = 1
  Sand = 2
  Pebbles = 3
  Player = 4
end


window = GameWindow.new
window.show
