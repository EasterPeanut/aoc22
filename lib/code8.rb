File.open('lib/grid.txt', 'r') do |file_handle|
  GRID = file_handle.map { |line| line.strip.split('').map(&:to_i) }
  MAX_ROW_IDX = GRID.length - 1
  MAX_COL_IDX = GRID[0].length - 1
  GRID.each { |l| pp l }

  def visible?(coordinates)
    tree_on_edge?(coordinates) or
      !any_blocking_tree(north_from: coordinates) or
      !any_blocking_tree(east_from: coordinates) or
      !any_blocking_tree(south_from: coordinates) or
      !any_blocking_tree(west_from: coordinates)
  end

  def tree_on_edge?((row_idx, col_idx))
    row_idx == (0 || MAX_ROW_IDX) or
      col_idx == (0 || MAX_COL_IDX)
  end

  def any_blocking_tree(options)
    case options
    in north_from:
      (row_idx, col_idx) = north_from
      prev_row = row_idx - 1

      (0..prev_row).any? do |n|
        GRID[n][col_idx] >= GRID[row_idx][col_idx]
      end
    in east_from:
      (row_idx, col_idx) = east_from
      next_col = col_idx + 1

      (next_col..MAX_COL_IDX).any? do |n|
        GRID[row_idx][n] >= GRID[row_idx][col_idx]
      end
    in south_from:
      (row_idx, col_idx) = south_from
      next_row = row_idx + 1

      (next_row..MAX_ROW_IDX).any? do |n|
        GRID[n][col_idx] >= GRID[row_idx][col_idx]
      end
    in west_from:
      (row_idx, col_idx) = west_from
      prev_col = col_idx - 1

      (0..prev_col).any? do |n|
        GRID[row_idx][n] >= GRID[row_idx][col_idx]
      end
    else
      'not matched'
    end
  end

  total = 0

  GRID.each_with_index do |row, row_idx|
    row.each_with_index do |_tree, col_idx|
      total += 1 if visible?([row_idx, col_idx])
    end
  end

  pp total
end
