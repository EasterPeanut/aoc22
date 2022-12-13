input = File.read('lib/signal.txt')
#   input.match(/(.)(?!\1)(.)(?!\1|\2)(.)(?!\1|\2|\3)(.)(?!\1|\2|\3|\4)/)
#   pp match[0]
#   pp Regexp.last_match.begin(0) + 1 + 4

(0...input.length).each do |idx|
  str = input[idx, 14]
  if str.split('').uniq.length == 14
    pp idx + 1 + 14
    break
  end
end
