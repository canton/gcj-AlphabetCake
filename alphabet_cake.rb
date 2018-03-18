#!/usr/bin/env ruby

class Cake
  def initialize(rows, columns, data)
    @rows = rows
    @columns = columns
    @data = data
  end

  attr_reader :rows, :columns, :data
end

class Area
  def initialize(name, top, bottom, left, right)
    @name = name
    @top = top
    @bottom = bottom
    @left = left
    @right = right
  end

  attr_reader :name, :top, :bottom, :left, :right

  def go_left(cake)
    return if left == 0
    c = left - 1
    _data = cake.data[top..bottom]
    if _data.all?{ |row| row[c] == '?' }
      @left = c
      _data.each{ |row| row[c] = name }
      true
    end
  end

  def go_right(cake)
    return if right == cake.columns - 1
    c = right + 1
    _data = cake.data[top..bottom]
    if _data.all?{ |row| row[c] == '?' }
      @right = c
      _data.each{ |row| row[c] = name }
      true
    end
  end

  def go_up(cake)
    return if top == 0
    r = top - 1
    row = cake.data[r]
    if row[left..right].all?{ |cell| cell == '?' }
      @top = r
      (left..right).each { |c| row[c] = name }
      true
    end
  end

  def go_down(cake)
    return if bottom == cake.rows - 1
    r = bottom + 1
    row = cake.data[r]
    if row[left..right].all?{ |cell| cell == '?' }
      @bottom = r
      (left..right).each{ |c| row[c] = name }
      true
    end
  end

  def to_s
    "#{top},#{bottom},#{left},#{right}"
  end
end

def solve(cake)
  areas = cake.data.each_with_index.map do |row, r|
    row.each_with_index.map do |cell, c|
      Area.new(cell, r, r, c, c) if cell != '?'
    end
  end.flatten.compact
  areas.each do |area|
    while area.go_left(cake) do; end
    while area.go_right(cake) do; end
  end
  areas.each do |area|
    while area.go_up(cake) do; end
    while area.go_down(cake) do; end
  end
  # areas.each{ |a| puts a }
end

def print(cake)
  cake.data.each do |row|
    puts row.join('')
  end
end

case_count = gets.chomp.to_i
case_count.times { |cc|
  r, c = gets.chomp.split(' ').map(&:to_i)
  data = r.times.map do |rr|
    gets.chomp.split('')
  end
  cake = Cake.new(r, c, data)

  puts "Case ##{cc+1}:"
  solve cake
  print cake
}
