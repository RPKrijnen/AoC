#=
--- Day 6: Trash Compactor ---
After helping the Elves in the kitchen, you were taking a break and helping them re-enact a movie scene when you over-enthusiastically jumped into the garbage chute!

A brief fall later, you find yourself in a garbage smasher. Unfortunately, the door's been magnetically sealed.

As you try to find a way out, you are approached by a family of cephalopods! They're pretty sure they can get the door open, but it will take some time. While you wait, they're curious if you can help the youngest cephalopod with her math homework.

Cephalopod math doesn't look that different from normal math. The math worksheet (your puzzle input) consists of a list of problems; each problem has a group of numbers that need to be either added (+) or multiplied (*) together.

However, the problems are arranged a little strangely; they seem to be presented next to each other in a very long horizontal list. For example:

123 328  51 64 
 45 64  387 23 
  6 98  215 314
*   +   *   +  
Each problem's numbers are arranged vertically; at the bottom of the problem is the symbol for the operation that needs to be performed. Problems are separated by a full column of only spaces. The left/right alignment of numbers within each problem can be ignored.

So, this worksheet contains four problems:

123 * 45 * 6 = 33210
328 + 64 + 98 = 490
51 * 387 * 215 = 4243455
64 + 23 + 314 = 401
To check their work, cephalopod students are given the grand total of adding together all of the answers to the individual problems. In this worksheet, the grand total is 33210 + 490 + 4243455 + 401 = 4277556.

Of course, the actual worksheet is much wider. You'll need to make sure to unroll it completely so that you can read the problems clearly.

Solve the problems on the math worksheet. What is the grand total found by adding together all of the answers to the individual problems?
=#
import Pkg; Pkg.add("CSV")
using CSV
using DataFrames


# Source - https://stackoverflow.com/a
# Posted by DNF, modified by community. See post 'Timeline' for change history
# Retrieved 2025-12-06, License - CC BY-SA 4.0

function undigits(d; base=10)
    (s, b) = promote(zero(eltype(d)), base)
    mult = one(s)
    for val in d
        s += val * mult
        mult *= b
    end
    return s
end



function convert_to_cephalopod_numbers(arr)
    ceph_numbers = zeros(length(arr))
    ceph_nr_lengths = []
    for nr in arr
        push!(ceph_nr_lengths, length(digits(nr)))
    end

    for idx in collect(length(arr):-1:1)
        for d in digits(nr)
            ceph_numbers[idx]
        end
    end
    return arr
end


function main(lines)
    n_rows = length(lines)
    n_cols = length(lines[1])

    operations = filter(x -> !isspace(x), lines[end])
    
    buffer = []
    buffer_idx = 0
    operation_idx = 0
    final_res = 0
    for idx in collect(1:n_cols)
        temp_res = ""
        for jdx in collect(1:n_rows-1)
            item = lines[jdx][idx]
            temp_res = temp_res*item
        end

        if temp_res != " "^(n_rows-1)
            # println("number: $(parse(Int, temp_res))")
            push!(buffer, parse(Int, temp_res))
            buffer_idx += 1
        else
            operation_idx+=1
            if operations[operation_idx] == '+'
                final_res += sum(buffer)
                # println("Buffer full operation = $(operations[operation_idx]), problem result = $(sum(buffer))")
            else
                final_res += prod(buffer)
                # println("Buffer full operation = $(operations[operation_idx]), problem result = $(prod(buffer))")
            end
            buffer = []  # empty buffer
            buffer_idx = 0
        end
    end

    # Empty buffer one final time
    operation_idx+=1
    if operations[operation_idx] == '+'
        final_res += sum(buffer)
        # println("Buffer full operation = $(operations[operation_idx]), problem result = $(sum(buffer))")
    else
        final_res += prod(buffer)
        # println("Buffer full operation = $(operations[operation_idx]), problem result = $(prod(buffer))")
    end

    return final_res
end


print(("="^10)*"Starting:"*("="^10)*"\n")
final_answer = 0
f = open("2025\\day06\\puzzle_input.txt", "r")
lines = readlines(f)
# println(data)
# df = CSV.read("2025\\day06\\dummy_data.csv", DataFrame; delim=" ", ignorerepeated=true, types=String, validate=false)
# nr_of_elements = size(df)
# println(nr_of_elements)

# println(lines)

final_answer = main(lines)


close(f)

println("Final answer=$(final_answer)")
print(("="^10) * "DONE" * ("="^10)*"\n")