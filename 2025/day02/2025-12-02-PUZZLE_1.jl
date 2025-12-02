import Pkg; Pkg.add("CSV")
using CSV
using DataFrames


print(("="^10)*"Starting:"*("="^10)*"\n")
df = CSV.read("2025\\day02\\puzzle_input.csv", DataFrame; types=String, validate=false)
nr_of_elements = size(df)[2]
# println(df)
function main()
    total = 0
    for col in eachcol(df)
        keys = split(string(col), "-")
        key1 = keys[1][3:end]
        key2 = keys[2][1:end-2]
        # Check for leading zeros
        if key1 == '0'
            #total += parse(Int, key1)
        elseif key2 == '0'
            #total += parse(Int, key2)
        else
            println("key1: $(key1), key2: $(key2)")  # Each row is a NamedTuple
            range = collect(parse(Int, key1):parse(Int, key2))
            # println(range)
            for item in range
                # Check for even lengths of numbers?
                # Check one half against the other half
                str_item = string(item)
                if str_item[1:end÷2]==str_item[end÷2+1:end]
                    total += item
                end
            end
        end
    end
    return total
end

final_result = main()
print("Final result: $(final_result)\n")
print(("="^10) * "DONE" * ("="^10)*"\n")