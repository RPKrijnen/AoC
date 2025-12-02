import Pkg; Pkg.add("CSV")
using CSV
using DataFrames


print(("="^10)*"Starting:"*("="^10)*"\n")
df = CSV.read("2025\\day02\\puzzle_input.csv", DataFrame; types=String, validate=false)
nr_of_elements = size(df)[2]

function main()
    part1 = 0
    part2 = 0
    for col in eachcol(df)
        keys = split(string(col), "-")
        key1 = keys[1][3:end]
        key2 = keys[2][1:end-2]
        range = collect(parse(Int, key1):parse(Int, key2))

        for item in range
            str_item = string(item)
            for idx in 1:length(str_item)÷2
                repeats, remainder = fldmod(length(str_item), idx)
                if (str_item[1:end÷2]^2 == str_item)
                    part1 += item
                    part2 += item
                    break
                elseif (str_item[1:idx]^repeats == str_item) && (remainder==0) # && (idx==1)
                    part2 += item
                    break
                end
            end
        end
    end
    return part1, part2
end

part1, part2 = main()
print("Final result part 1: $(part1), Final result part 2: $(part2)\n")
print(("="^10) * "DONE" * ("="^10)*"\n")