File.open('lib/instructions.txt', 'r') do |file_handle|
  GRID = [
    '......',
    '......',
    '......',
    '......',
    'H.....'
  ]
  $head = [0, 0]
  $tail = [0, 0]

  GRID.each_with_index do |row, row_idx|
    col_idx = row.index('H')
    next unless col_idx

    $head = [row_idx, col_idx]
    $tail = $head
    START = $head
  end

  def move_tail(heads_prev_position)
    # do nothing if:
    #   head is over tail
    #   head is adjacent to tail
    row_diff = ($head[0] - $tail[0]).abs
    col_diff = ($head[1] - $tail[1]).abs

    return unless row_diff > 1 || col_diff > 1

    # move tail to head's previous position
    $tail = heads_prev_position
  end

  def move(direction, number_of_steps)
    (1..number_of_steps).each do |_step|
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

      move_tail(heads_prev_position)
    end
  end

  file_handle.each do |instruction|
    direction, number_of_steps = instruction.strip.split(' ')
    move(direction, number_of_steps.to_i)
  end
end
