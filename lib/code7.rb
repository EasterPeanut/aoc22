system = {}
cwd = []

File.open('lib/browse_history.txt', 'r') do |file_handle|
  file_handle.each_line do |line|
    case line.strip
    when '$ cd ..'
      cwd.pop(1)
    when /\$ cd (.*)/
      cwd << Regexp.last_match(1)
    when /(\d*) .*/
      cwd.each do |dir|
        cwd_str = cwd[0..cwd.index(dir)].join('/')
        if system.key?(cwd_str)
          system[cwd_str] += Regexp.last_match(1).to_i
        else
          system[cwd_str] = Regexp.last_match(1).to_i
        end
      end
    end
  end
end

DISK_SPACE = 70_000_000
SPACE_NEEDED_FOR_UPDATE = 30_000_000

current_system_space = DISK_SPACE - system['/']
system_space_to_be_freed = SPACE_NEEDED_FOR_UPDATE - current_system_space
pp system_space_to_be_freed

pp system.reject { |_k, v| v < system_space_to_be_freed }.min_by { |_k, v| v }
