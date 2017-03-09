# Reads 9 * 9 board in the format like:
# 0 2 0 6 5 7 0 8 4
# 0 0 6 0 8 0 9 0 0
# 0 7 0 1 0 9 0 2 0
# 6 4 0 0 7 0 0 9 1
# 9 0 7 0 0 0 4 0 8
# 0 8 1 9 0 4 5 3 0
# 5 9 8 0 0 0 3 4 2
# 0 3 0 4 0 8 0 5 6
# 0 0 0 5 0 3 0 0 0

rust = false

board = (0 ... 9).map{|v| gets.split.map(&:to_i)}

# 0 is regarded as a blank cell
# Make a CNF formula


cnf = []
# v_ijk: the number in the cell ij is k
(0 ... 81).each {|cell|
  # every cell should contain at least one of 1-9.
  cnf << (9 * cell + 1 .. 9 * cell + 9).to_a
  # No cell contains more than one of 1-9.
  (1 .. 8).each {|i|
    (i + 1 .. 9).each {|j|
      cnf << [- (9 * cell + i), - (9 * cell + j)]
    }
  }
}

# every row contains each of 1-9 exactly once
(0 ... 9).each {|row|
  (1 .. 9).each {|num|
    cnf << (0 ... 9).map{|col| 9 * (9 * row + col) + num}
  }
}
# every column contains each of 1-9 exactly once
(0 ... 9).each {|col|
  (1 .. 9).each {|num|
    cnf << (0 ... 9).map{|row| 9 * (9 * row + col) + num}
  }
}

# every 3 * 3 cell contains each of 1-9 exactly once
(0 ... 3).each {|r|
  (0 ... 3).each {|c|
    (1 .. 9).each {|num|
      clause = []
      (0 ... 3).each{|r2|
        (0 ... 3).each{|c2|
          clause << (9 * (9 * (3 * r + r2) + 3 * c + c2) + num)
        }
      }
      cnf << clause
    }
  }
}

# reads the board
(0 ... 9).each {|row|
  (0 ... 9).each {|col|
    b = board[row][col]
    if b != 0
      cnf << [9 * (9 * row + col) + b]
    end
  }
}


# emit CNF

# Allow pipes

tmp_infile = "/tmp/sat-interm.cnf"
tmp_outfile = "/tmp/sat-output.out"

open(tmp_infile, "w") {|fp|
  fp.puts "p cnf"
  fp.puts "729 #{cnf.size}"
  cnf.each {|clause|
    fp.puts (clause + [0]).join(' ')
  }
}

# invoke minisat
system("minisat#{rust ? "-rust" : ""} #{tmp_infile} #{tmp_outfile}")

open(tmp_outfile, "r") {|fp|
  fp.gets
  nums = fp.gets.split.map(&:to_i)
  result = Array.new(9).map{|_| Array.new(9, nil)}
  nums.each {|v|
    if v > 0
      cell = (v - 1) / 9
      n = v - 9 * cell
      result[cell / 9][cell % 9] = n
    end
  }
  result.each {|row|
    puts row.join(' ')
  }
}
