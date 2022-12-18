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
