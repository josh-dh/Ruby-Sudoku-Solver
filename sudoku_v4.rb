#board printing

require 'matrix'

$boardnumbers = [0..8, 9..17, 18..26, 27..35, 36..44, 45..53, 54..62, 63..71, 72..80]

def pretty_board(board)
	output = board.to_a.map do |x|
		x = x.join("  ")
		x << "\n"
	end
	output.join()
end

def readstr(string)
	arr = []
	string.each_char do |y|
		arr << y
	end
	arr.delete("\n")
	output = []
	$boardnumbers.each do |x|
		output << arr[x]
	end
	mat = Matrix.rows(output)
	return mat
end

def findsquare(rowindex, columnindex) #NOT REFACTORED
	for i in 0..8
		output = i if [[0,1,2], [0,1,2], [0,1,2], [3,4,5], [3,4,5], [3,4,5], [6,7,8], [6,7,8], [6,7,8]][i].include?(rowindex) && [[0,1,2], [3,4,5], [6,7,8], [0,1,2], [3,4,5], [6,7,8], [0,1,2], [3,4,5], [6,7,8]][i].include?(columnindex)
	end
	return output
end

def formatboard(str, type)

	arr = [[],[],[],[],[],[],[],[],[]]
	j = -1
	for i in 0..80
		k = 0 if i % 9 == 0
		j += 1 if i % 9 == 0
		arr[j] << str[i] if type == "row"
		arr[k] << str[i] if type == "column"
		arr[findsquare(j,k)] << str[i] if type == "block" #TEMPORARY UNTIL REFACTORING OF row ASSIGNMENT CODE
		k += 1
	end
	return arr
end

def solve_with_backtracking(origstr)
	tempstring = origstr.dup
	empty_indices = []
	for i in 0..80
		empty_indices << i if origstr[i] == "-"
	end
	p empty_indices
	def valid_number_for_index(origstr, index_, number)
		$solved = true
		#find_row
		if (0..8).to_a.include?(index_)
			row = 0
		elsif (9..17).to_a.include?(index_)
			row = 1
		elsif (18..26).to_a.include?(index_)
			row = 2
		elsif (27..35).to_a.include?(index_)
			row = 3
		elsif (36..44).to_a.include?(index_)
			row = 4
		elsif (45..53).to_a.include?(index_)
			row = 5
		elsif (54..62).to_a.include?(index_)
			row = 6
		elsif (63..71).to_a.include?(index_)
			row = 7
		elsif (72..80).to_a.include?(index_)
			row = 8
		end
		#find_column
		if index_ % 9 == 0
			column = 0
		elsif index_ % 9 == 1
			column = 1
		elsif index_ % 9 == 2
			column = 2
		elsif index_ % 9 == 3
			column = 3
		elsif index_ % 9 == 4
			column = 4
		elsif index_ % 9 == 5
			column = 5
		elsif index_ % 9 == 6
			column = 6
		elsif index_ % 9 == 7
			column = 7
		elsif index_ % 9 == 8
			column = 8
		end
		#find_block
		block = findsquare(row, column)
		def solvedeach(str, methodused, index_, number)
			x = formatboard(str, methodused)[index_]
				$solved = false if x.include?(number)
		end
		solvedeach(origstr,"row", row, number)
		solvedeach(origstr,"column", column, number)
		solvedeach(origstr,"block", block, number)
		return $solved
	end
	def solve(str, index_, empty_indices)
		if str[empty_indices[index_]] == "-"
			num = 1
		else
			num = str[empty_indices[index_]].to_i + 1
		end
		until valid_number_for_index(str, empty_indices[index_], num.to_s)
			num += 1
			break if num == 10
		end
		p str
		if num == 10
			str[empty_indices[index_]] = "-"
			solve(str, index_ - 1, empty_indices)
		else
			str[empty_indices[index_]] = num.to_s
			if index_ + 2 > empty_indices.count
			else
				solve(str, index_+1, empty_indices)
			end
		end
	end
	solve(tempstring, 0, empty_indices)
	return tempstring
end

p solve_with_backtracking("-96-4---11---6---45-481-39---795--43-3--8----4-5-23-18-1-63--59-59-7-83---359---7")
