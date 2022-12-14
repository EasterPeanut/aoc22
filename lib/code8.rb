File.open('lib/grid.txt', 'r') do |file_handle|
  GRID = file_handle.map { |line| line.strip.split('').map(&:to_i) }
  MAX_ROW_IDX = GRID.length - 1
  MAX_COL_IDX = GRID[0].length - 1

  def part1
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

  def part2
    def scenic_score(coordinates)
      viewing_distance(for_north: coordinates) *
        viewing_distance(for_east: coordinates) *
        viewing_distance(for_south: coordinates) *
        viewing_distance(for_west: coordinates)
    end

    def viewing_distance(options)
      distance = 0

      case options
      in for_north:
        (row_idx, col_idx) = for_north
        prev_row = row_idx - 1

        return distance if row_idx < 0

        prev_row.downto(0).to_a.each do |n|
          distance += 1
          break if GRID[n][col_idx] >= GRID[row_idx][col_idx]
        end

        distance
      in for_east:
        (row_idx, col_idx) = for_east
        next_col = col_idx + 1

        return distance if col_idx > MAX_COL_IDX

        next_col.upto(MAX_COL_IDX).to_a.each do |n|
          distance += 1
          break if GRID[row_idx][n] >= GRID[row_idx][col_idx]
        end

        distance
      in for_south:
        (row_idx, col_idx) = for_south
        next_row = row_idx + 1

        return distance if row_idx > MAX_ROW_IDX

        next_row.upto(MAX_ROW_IDX).to_a.each do |n|
          distance += 1
          break if GRID[n][col_idx] >= GRID[row_idx][col_idx]
        end

        distance
      in for_west:
        (row_idx, col_idx) = for_west
        prev_col = col_idx - 1

        return distance if col_idx < 0

        prev_col.downto(0).to_a.each do |n|
          distance += 1
          break if GRID[row_idx][n] >= GRID[row_idx][col_idx]
        end

        distance
      else
        'not matched'
      end
    end

    scenic_scores = []
    GRID.each_with_index do |row, row_idx|
      row.each_with_index do |_tree, col_idx|
        scenic_scores << scenic_score([row_idx, col_idx])
      end
    end
    scenic_scores
  end

  pp part2.max
end
