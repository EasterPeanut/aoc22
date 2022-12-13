total = 0
File.open('lib/tasks.txt', 'r') do |file_handle|
  file_handle.each_line do |pair|
    arr = []
    pair.strip.split(',').each do |elf|
      range_arr = elf.split('-')
      arr << (range_arr[0].to_i..range_arr[1].to_i).to_a
    end

    # if [(arr[0] - arr[1]), (arr[1] - arr[0])].any?([])
    total += 1 if (arr[0] & arr[1]).length > 0
  end
end
pp total
