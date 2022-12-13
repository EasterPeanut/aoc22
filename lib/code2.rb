  A = [
    "A",
    "B",
    "C"
  ]

  H = Hash[
    AA: 3 + 1,
    AB: 6 + 2,
    AC: 0 + 3,
    BA: 0 + 1,
    BB: 3 + 2,
    BC: 6 + 3,
    CA: 6 + 1,
    CB: 0 + 2,
    CC: 3 + 3
  ]

  total = 0

  File.open("rps.txt", "r") do |file_handle|
    file_handle.each_line do |round|
      pp round # original
      round["\n"] = ""
      round[" "] = ""

      index_opponent =
        case round[0]
          when "A"; 0
          when "B"; 1
          when "C"; 2
        end

      index_shift =
        case round[1]
          when "X"; -1
          when "Y"; 0
          when "Z"; -2
        end

      final_index = index_opponent + index_shift
      pp str = round[0] + A[final_index]

      total += H[str.to_sym]
    end
  end

  pp total

