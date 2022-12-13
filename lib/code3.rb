H1 = ('a'..'z').map.with_index { |char, i| [char, i + 1] }.to_h
H2 = ('A'..'Z').map.with_index { |char, i| [char, i + 1 + 26] }.to_h
H = H1.merge(H2)

def part1
  total = 0
  File.open('lib/rucksacks.txt', 'r') do |file_handle|
    file_handle.each_line do |rucksack|
      item_count = rucksack.length

      compartment1 = rucksack[0, item_count / 2]
      compartment2 = rucksack[item_count / 2, item_count]

      pp match = compartment1.match(/[#{Regexp.quote(compartment2)}]/)

      if match
        char = match[0]
        total += H[char]
      end
    end
  end
  total
end

def part2
  total = 0
  File.open('lib/rucksacks.txt', 'r') do |file_handle|
    file_handle.each_slice(3) do |group|
      arr = group[0].strip.chars & group[1].strip.chars & group[2].strip.chars

      if arr.length > 0
        pp arr[0]
        total += H[arr[0]]
      end
    end
  end
  total
end

pp part2
