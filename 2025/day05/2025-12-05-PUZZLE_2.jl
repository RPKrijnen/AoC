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

Your puzzle answer was 865.

The first half of this puzzle is complete! It provides one gold star: *
--- Part Two ---

The Elves start bringing their spoiled inventory to the trash chute at the back of the kitchen.

So that they can stop bugging you when they get new inventory, the Elves would like to know all of the IDs that the fresh ingredient ID ranges consider to be fresh. An ingredient ID is still considered fresh if it is in any range.

Now, the second section of the database (the available ingredient IDs) is irrelevant. Here are the fresh ingredient ID ranges from the above example:

3-5
10-14
16-20
12-18

The ingredient IDs that these ranges consider to be fresh are 3, 4, 5, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, and 20. So, in this example, the fresh ingredient ID ranges consider a total of 14 ingredient IDs to be fresh.

Process the database file again. How many ingredient IDs are considered to be fresh according to the fresh ingredient ID ranges?


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

function count_range_length(range_matrix)
    matrix_size = range_matrix.size
    max_nr = 0
    for idx in collect(1:matrix_size[2])
        range_collection = range_matrix[2, idx] - range_matrix[1, idx] + 1
        max_nr += range_collection
    end
    return max_nr
end

function count_fresh_ingredient_ids(range_matrix, id_collection)
    nr_fresh = 0
    for id in id_collection
        freshness = range_matrix[2, :] .>= id .>= range_matrix[1, :]
        if sum(freshness) > 0
            nr_fresh += 1
        end
    end
    return nr_fresh
end

function increase_minimum_range(sorted_mat)
    matrix_size = sorted_mat.size
    no_overlap_matrix = sorted_mat

    for idx in collect(2:matrix_size[2])
        if sorted_mat[1, idx] <= sorted_mat[2, idx-1]
            sorted_mat[1, idx] = sorted_mat[2, idx-1] + 1
        end
    end
    return no_overlap_matrix
end

print(("="^10)*"Starting:"*("="^10)*"\n")

f = open("2025\\day05\\puzzle_input.txt", "r")
data = readlines(f)

# Split dataset into two
ranges, IDs = split_database(data)
range_matrix = hcat(ranges...)

# Check valid IDs against the set
nr_fresh_ingredients_in_collection = count_fresh_ingredient_ids(range_matrix, IDs)

# To check for the second part we first check if both the minimum and maximum ranges are sorted the same way
@assert sum(sortperm(range_matrix[2, :]) - sortperm(range_matrix[1, :])) == 0

sorted_matrix = sort(range_matrix, dims=2)

# Now we increase the minimum sequentially by checking if each subsequent range has a lower minimum than the previous maximum
no_overlap_matrix = increase_minimum_range(sorted_matrix)
display(range_matrix)
display(no_overlap_matrix)
max_nr_fresh = count_range_length(no_overlap_matrix)

close(f)

println("Nr of fresh ingredients in the collection=$(nr_fresh_ingredients_in_collection)")
println("Maximum nr of fresh ingredients=$(max_nr_fresh)")
print(("="^10) * "DONE" * ("="^10)*"\n")