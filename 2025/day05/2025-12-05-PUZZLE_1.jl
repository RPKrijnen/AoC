#=
--- Day 5: Cafeteria ---

As the forklifts break through the wall, the Elves are delighted to discover that there was a cafeteria on the other side after all.

You can hear a commotion coming from the kitchen. "At this rate, we won't have any time left to put the wreaths up in the dining hall!" Resolute in your quest, you investigate.

"If only we hadn't switched to the new inventory management system right before Christmas!" another Elf exclaims. You ask what's going on.

The Elves in the kitchen explain the situation: because of their complicated new inventory management system, they can't figure out which of their ingredients are fresh and which are spoiled. When you ask how it works, they give you a copy of their database (your puzzle input).

The database operates on ingredient IDs. It consists of a list of fresh ingredient ID ranges, a blank line, and a list of available ingredient IDs. For example:

3-5
10-14
16-20
12-18

1
5
8
11
17
32

The fresh ID ranges are inclusive: the range 3-5 means that ingredient IDs 3, 4, and 5 are all fresh. The ranges can also overlap; an ingredient ID is fresh if it is in any range.

The Elves are trying to determine which of the available ingredient IDs are fresh. In this example, this is done as follows:

    Ingredient ID 1 is spoiled because it does not fall into any range.
    Ingredient ID 5 is fresh because it falls into range 3-5.
    Ingredient ID 8 is spoiled.
    Ingredient ID 11 is fresh because it falls into range 10-14.
    Ingredient ID 17 is fresh because it falls into range 16-20 as well as range 12-18.
    Ingredient ID 32 is spoiled.

So, in this example, 3 of the available ingredient IDs are fresh.

Process the database file from the new inventory management system. How many of the available ingredient IDs are fresh?

=#

function split_database(data)
    fill_IDs = false
    ranges = []
    IDs = []
    for line in data
        if line == "" && fill_IDs == false
            fill_IDs = true
        elseif fill_IDs == false
            min_range, max_range = split(line, '-')
            push!(ranges, [parse(Int, min_range), parse(Int, max_range)])
        else
            push!(IDs, parse(Int, line))
        end
    end
    return ranges, IDs
end

function create_range_set(ranges)
    range_set = Set()
    for range in ranges
        range_collection = collect(range[1]:range[2])
        push!(range_set, range_collection...) 
    end
    return range_set
end

# function count_fresh_ingredients(range_set, id_collection)
#     nr_fresh = 0
#     for id in id_collection
#         if id ∈ range_set
#             nr_fresh += 1
#         end
#     end
#     return nr_fresh
# end

function count_fresh_ingredients(range_matrix, id_collection)
    nr_fresh = 0
    for id in id_collection
        freshness = range_matrix[2, :] .>= id .>= range_matrix[1, :]
        if sum(freshness) > 0
            nr_fresh += 1
        end
    end
    return nr_fresh
end

print(("="^10)*"Starting:"*("="^10)*"\n")

f = open("2025\\day05\\puzzle_input.txt", "r")
data = readlines(f)
# println(data)

# Split dataset into two
ranges, IDs = split_database(data)
# println("ranges: $(ranges)")
# println("IDs: $(IDs)")

# Create set of ranges, which is apparently very emmory intensive
# range_set = create_range_set(ranges)
# println("range_set: $(range_set)")
range_matrix = hcat(ranges...)

# Check valid IDs against the set
nr_fresh_ingredients = count_fresh_ingredients(range_matrix, IDs)

close(f)

println("Nr of fresh ingredients=$(nr_fresh_ingredients)")
print(("="^10) * "DONE" * ("="^10)*"\n")