first, second = File.read('lib/crates.txt').split("\n\n")
stacks = []
mapper = {}

first.split("\n").reverse.each do |line|
  if line.match?(/^[\d\s]+$/)
    mapper = line.gsub(/\d/).map do
      stack_match = Regexp.last_match
      stack_number = stack_match[0].to_i

      stacks[stack_number] = []
      [stack_match.begin(0), stack_number]
    end.to_h
  else
    line.gsub(/[A-Z]/).map do
      crate_match = Regexp.last_match
      stacks[mapper[crate_match.begin(0)]] << crate_match[0]
    end
  end
end

pp stacks

second.split("\n").each do |line|
  match = line.match(/^move (\d*) from (\d) to (\d)/)
  number_of_crates = match[1].to_i
  from = match[2].to_i
  to = match[3].to_i

  # stacks[to].concat stacks[from].pop(number_of_crates).reverse
  stacks[to].concat stacks[from].pop(number_of_crates)
end

pp stacks

str = ''
stacks.each { |stack| str += stack.last if stack }
pp str
