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
    @image = Gosu::Image.new(self, "big_sprite_forwards.png", true)
    @world = World.new(self)
    @player = Player.new(self)
    @player.warp(340, 423)
    @camera_x = @player.x - @width/2
    @camera_y = @player.y - @height/2
    @player_jumped = false
    @jump_counter = 0
    @player_y_before_jump = 423
  end

  def draw
    @world.draw(-@camera_x, -@camera_y, @width, @height, @camera_x, @camera_y)
    @player.image.draw_rot(@player.x - @camera_x, @player.y - @camera_y, 1, 0.0)
  end


  def update
    puts @player_jumped
#    if @player_y_before_jump > (@player.y - 0.8)
  #    @player_jumped = false
 #   end
    
    if @player_jumped == true && (not (@player.y > @player_y_before_jump - 0.8))
      if @jump_counter >= 40
        @player.jump(-1)
        @player_jumped = false
        @jump_counter = 0
      else
        @jump_counter += 1
      end
    end
    
    if button_down? Gosu::KbA then
      @player.accelerate_backwards(0.65)
    end
    if button_down? Gosu::KbD then
      @player.accelerate_forwards(0.65)
    end
    if button_down? Gosu::KbW 
      @player.unshrink
    end
    
    if @player.y > (@player_y_before_jump - 0.8)
      if button_down? Gosu::KbSpace and !@pressed
        @pressed=true
        @player.jump(1)
        @player_jumped = true
      elsif not button_down?(Gosu::KbSpace)
        @pressed=nil
      end
    end
    if not @player_jumped
      @player_y_before_jump = @player.y
    end 
    if button_down? Gosu::KbS then
      puts "shrink"
      @player.shrink
    end 
    @player.move
    @camera_x = @player.x - @width/2
      @camera_y = 423 - @height/2
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
        if x <= 100/7
          Tiles::Sky
        else
          Tiles::Grass
        end
      end
    end
  end

  def draw(offset_x, offset_y, max_width, max_height, camera_x, camera_y)
    n = Time.now
    startx = [(camera_x.to_i/32), 0].max
    finish_x = [(camera_x+max_width+1).to_i/32, 1999].min
    starty = [(camera_y.to_i/32), 0].max
    finish_y = [(camera_y+max_height+1).to_i/32, 1999].min
    (starty..finish_y).each do |y|
      if (y * 32) > (max_height + camera_y)
        break
      end
      if (y * 32 + 32) < camera_y
        next
      end
      (startx..finish_x).each do |x|
        if (x * 32) > (max_width + camera_x)
          break
        end
        if (x * 32 + 32) < camera_x
          next
        end
        tile = @tilemap[x][y]
        if tile
          @tileset[tile].draw(x * 32 + offset_x, y * 32 + offset_y, 0)
        end
      end
    end
    m = Time.now
    x = ((m - n)*1000).to_i
  end
  
  def place_obstacle
    
  end
  
end

class Player
  
  attr_reader :x, :y, :image
  
  def initialize(window)
    @big_image = Gosu::Image.new(window, "big_sprite_forwards.png", false)
    @small_image = false
    @image = @big_image
    @x = @y = @vel_x = @vel_y = @angle = 0.0
    @score = 0
    @jumped = false
    unshrink
  end
  
  def unshrink
    @size = 2
  end
  
  def shrink
    @size = 1
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

	def jump(modifier)
	  if modifier == 1
      @vel_y += Gosu::offset_y(0.0, 2.5)
    else
      @vel_y -= Gosu::offset_y(0.0, 2.5)
    end
	end

  def accelerate_forwards(acceleration)
    @vel_x += Gosu::offset_x(@angle + 90, acceleration)
    @vel_y += Gosu::offset_y(@angle + 90, acceleration)
  end
  
  def accelerate_backwards(acceleration)
    @vel_x -= Gosu::offset_x(@angle + 90, acceleration)
    @vel_y -= Gosu::offset_y(@angle + 90, acceleration)
  end

  def move
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
    @image.draw_rot(@x, @y, 1, @angle, 0.5, 1, @size, @size)
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
