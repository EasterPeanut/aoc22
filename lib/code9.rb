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

def part2
  File.open('lib/instructions.txt', 'r') do |file_handle|
    $rope = (0..9).map { [0, 0] }
    $prev_knot_left_pos = [0, 0]
    $tail_positions = ['0/0']

    def move(direction, number_of_steps)
      number_of_steps.times.each do |_step|
        $rope.each_with_index do |knot, i|
          knot_copy = knot.map(&:clone)

          if i == 0
            case direction
            when 'U'
              knot[0] -= 1
            when 'R'
              knot[1] += 1
            when 'D'
              knot[0] += 1
            when 'L'
              knot[1] -= 1
            end
          else

            # next unless i == 9

            # do nothing if:
            #   head is over tail
            #   head is adjacent to tail
            row_diff = ($rope[i - 1][0] - knot[0]).abs
            col_diff = ($rope[i - 1][1] - knot[1]).abs

            if [row_diff, col_diff].max > 1

              # move tail to last knot's previous position
              $rope[i] = $prev_knot_left_pos

              $tail_positions << "#{$rope[i][0]}/#{$rope[i][1]}" if i == 9
            end
          end

          $prev_knot_left_pos = knot_copy
        end
      end
    end

    file_handle.each do |instruction|
      direction, number_of_steps = instruction.strip.split(' ')
      move(direction, number_of_steps.to_i)
    end

    pp $tail_positions.uniq.count
  end
end

part2
