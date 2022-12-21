def part1
  File.open('lib/instructions.txt', 'r') do |file_handle|
    $head = [0, 0]
    $tail = [0, 0]
    $tail_positions = ['0/0']

    def move(direction, number_of_steps)
      number_of_steps.times.each do |_step|
        heads_prev_position = $head
        row_idx, col_idx    = $head

        case direction
        when 'U'
          $head = [row_idx - 1, col_idx]
        when 'R'
          $head = [row_idx, col_idx + 1]
        when 'D'
          $head = [row_idx + 1, col_idx]
        when 'L'
          $head = [row_idx, col_idx - 1]
        end

        # do nothing if:
        #   head is over tail
        #   head is adjacent to tail
        row_diff = ($head[0] - $tail[0]).abs
        col_diff = ($head[1] - $tail[1]).abs

        # next if row_diff > 1 || col_diff > 1
        next if [row_diff, col_diff].max <= 1

        # move tail to head's previous position
        $tail = heads_prev_position

        $tail_positions << "#{$tail[0]}/#{$tail[1]}"
      end
    end

    file_handle.each do |instruction|
      direction, number_of_steps = instruction.strip.split(' ')
      move(direction, number_of_steps.to_i)
    end

    pp $tail_positions.uniq.count
  end
end

class Point
  attr_accessor :y, :x, :bg

  def initialize(*args)
    @y, @x = args

    @bg = args != [0, 0] ? '.' : 's'
  end
end

class Grid
  attr_accessor :points

  def initialize(instructions)
    @rope = []

    current_pos = [0, 0]
    positions = []

    instructions.each do |direction, iterations|
      case direction
      when 'U'
        current_pos[0] += iterations
      when 'R'
        current_pos[1] += iterations
      when 'D'
        current_pos[0] -= iterations
      when 'L'
        current_pos[1] -= iterations
      end

      positions << current_pos.map(&:clone)
    end

    minY, maxY = positions.minmax { |a, b| a[0] <=> b[0] }
    minX, maxX = positions.minmax { |a, b| a[1] <=> b[1] }

    @points = (minY[0]..maxY[0]).map do |y|
      [y, (minX[1]..maxX[1]).map { |x| Point.new(y, x) }]
    end.reverse.to_h
  end

  def find_point_by((x, y))
    @points[y].find { |p| p.x == x }
  end

  def add_rope(rope)
    @rope = rope
  end

  def print
    @points.sort { |a, b| b <=> a }.each do |_y, points|
      row_str = ''
      points.each do |p|
        knot_on_point = @rope.knots.find { |k| [k.y, k.x] == [p.y, p.x] }
        point = knot_on_point ? knot_on_point.fg.to_s : p.bg
        row_str << point + ' '
      end
      p row_str
    end
  end
end

class Rope
  attr_accessor :knots

  def initialize(length)
    @knots = length.times.map do |i|
      if i == 0
        fg = 'H'
        $prev_knot = Knot.new(y: 0, x: 0, fg:)
      else
        $prev_knot = Knot.new(y: 0, x: 0, fg: i, before: $prev_knot)
      end
    end
  end

  def move(direction)
    @knots.each do |knot|
      if knot.before
        next if [(knot.before.y - knot.y).abs, (knot.before.x - knot.x).abs].max <= 1

        knot.move_near(knot.before)
      else
        knot.move(direction)
      end
    end
  end
end

class Knot
  attr_accessor :y, :x, :fg, :before

  def initialize(y:, x:, fg:, before: nil)
    @y = y
    @x = x
    @fg = fg
    @before = before
  end

  def move(direction)
    case direction
    when 'U'
      @y += 1
    when 'R'
      @x += 1
    when 'D'
      @y -= 1
    when 'L'
      @x -= 1
    end

    self
  end

  def move_near(knot)
    position_candidates = {
      up: [knot.y + 1, knot.x],
      right: [knot.y, knot.x + 1],
      down: [knot.y - 1, knot.x],
      left: [knot.y, knot.x - 1]
    }

    diffs = {
      up: [(position_candidates[:up][0] - @y).abs, (position_candidates[:up][1] - @x).abs],
      right: [(position_candidates[:right][0] - @y).abs, (position_candidates[:right][1] - @x).abs],
      down: [(position_candidates[:down][0] - @y).abs, (position_candidates[:down][1] - @x).abs],
      left: [(position_candidates[:left][0] - @y).abs, (position_candidates[:left][1] - @x).abs]
    }

    key, _diff = diffs.min_by { |_k, v| v[0] + v[1] + (v[0] - v[1]).abs }
    @y, @x = position_candidates[key]
  end
end

def part2
  $instructions = File.open('lib/instructions.txt', 'r').map do |file_handle|
    direction, iterations_str = file_handle.strip.split(' ')

    [direction, iterations_str.to_i]
  end

  $grid = Grid.new($instructions)
  $rope = Rope.new(10)

  $grid.add_rope($rope)

  $instructions.each do |direction, iterations|
    iterations.times do |_i|
      $rope.move(direction)
      $grid.print
      sleep 0.2
    end
  end
end

part2
