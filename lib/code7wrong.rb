system = {}
cwd = []
listing = false

File.open('lib/browse_history.txt', 'r') do |file_handle|
  file_handle.each_line do |line|
    case line.strip
    when '$ cd ..'
      cwd.pop(1)
      listing = false
    when /\$ cd (.*)/
      cwd << Regexp.last_match(1)
      cwd.reduce(system) do |acc, i|
        acc[i] = {} unless acc.key?(i)
        acc[i]
      end
      listing = false
    when '$ ls'
      listing = true
    when listing && /dir (.*)/
      cwd_in_hash = cwd.reduce(system) { |acc, i| acc[i] }
      cwd_in_hash[Regexp.last_match(1)] = {} unless cwd_in_hash.key?(Regexp.last_match(1))
    when listing && /(\d*) (.*)/
      cwd_in_hash = cwd.reduce(system) { |acc, i| acc[i] }
      # cwd_in_hash[$2] = $1.to_i
      if cwd_in_hash.key?('filesizes')
        cwd_in_hash['filesizes'] += Regexp.last_match(1).to_i
      else
        cwd_in_hash['filesizes'] =
      0
      end
    end
  end
end

# def flatten_hash(hash)
#   hash.each_with_object({}) do |(k, v), h|
#     if v.is_a? Hash
#       flatten_hash(v).map do |h_k, h_v|
#         if h_k == "filesizes"
#           h["#{k}"] = h_v
#         else
#           h["#{k}/#{h_k}"] = h_v
#         end
#       end
#     else
#       h[k] = v
#     end
#   end
# end

# pp system
# pp flat_system = flatten_hash(system).reject { |k, v| v == 0 || v > 100000 }.sum { |k,v| v }
# hash = {}

# flat_system.each do |k, v|
#   dirs_in_line = k[2..k.length].split("/")
#   dirs_in_line.each do |dir|
#     if hash.key?(dir)
#       hash[dir] += v
#     else
#       hash[dir] = v
#     end
#   end
# end
# pp hash.reject { |k, v| v == 0 || v > 100000 }.sum {|k, v| v }
