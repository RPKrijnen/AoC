#=
--- Day 4: Printing Department ---

You ride the escalator down to the printing department. They're clearly getting ready for Christmas; they have lots of large rolls of paper everywhere, and there's even a massive printer in the corner (to handle the really big print jobs).

Decorating here will be easy: they can make their own decorations. What you really need is a way to get further into the North Pole base while the elevators are offline.

"Actually, maybe we can help with that," one of the Elves replies when you ask for help. "We're pretty sure there's a cafeteria on the other side of the back wall. If we could break through the wall, you'd be able to keep moving. It's too bad all of our forklifts are so busy moving those big rolls of paper around."

If you can optimize the work the forklifts are doing, maybe they would have time to spare to break through the wall.

The rolls of paper (@) are arranged on a large grid; the Elves even have a helpful diagram (your puzzle input) indicating where everything is located.

For example:

..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@.

The forklifts can only access a roll of paper if there are fewer than four rolls of paper in the eight adjacent positions. If you can figure out which rolls of paper the forklifts can access, they'll spend less time looking and more time breaking down the wall to the cafeteria.

In this example, there are 13 rolls of paper that can be accessed by a forklift (marked with x):

..xx.xx@x.
x@@.@.@.@@
@@@@@.x.@@
@.@@@@..@.
x@.@@@@.@x
.@@@@@@@.@
.@.@.@.@@@
x.@@@.@@@@
.@@@@@@@@.
x.x.@@@.x.

Consider your complete diagram of the paper roll locations. How many rolls of paper can be accessed by a forklift?

=#

# This is a convolution task with a kernel of size 3x3
# The kernel may extend one element outside of the bounding box
# I can turn all @s into 1s and .s into 0s and use an all ones kernel
# the kernel will dot multiply with the field and sum over all elements
# the result is the number of adjacent rolls of paper for each roll
# To get the final result we simply have to find all entries smaller than 4
# and count how many of those there are.

# But first I'd have to convert the @s into 1s and .s into 0s
# ascii code for @: 01000000 / 64
# ascii code for .: 00101110 / 46
# difference: 18

function convert_rolls_to_binary(rolls)
    temp_grid = []
    for roll in rolls
        int_roll = [r=='.' ? 0 : 1 for r in collect(roll)]  # convert(Int, r)
        push!(temp_grid, int_roll)
    end
    grid = vcat(transpose.(temp_grid)...)
    return grid
end

function convolve_rolls(X)
    X_size = size(X)
    X_padded = zeros(X_size[1]+2, X_size[2]+2)
    X_padded[2:end-1, 2:end-1] = X

    result = zeros(size(X_padded))

    K = [1 1 1; 1 1 1; 1 1 1]

    for x1 in 2:X_size[1]+1
        for x2 in 2:X_size[2]+1
            x11 = X_padded[x1-1, x2+1]
            x12 = X_padded[x1, x2+1]
            x13 = X_padded[x1+1, x2+1]

            x21 = X_padded[x1-1, x2]
            x22 = X_padded[x1, x2]
            x23 = X_padded[x1+1, x2]

            x31 = X_padded[x1-1, x2-1]
            x32 = X_padded[x1, x2-1]
            x33 = X_padded[x1+1, x2-1]

            result[x1, x2] = sum([x11 x12 x13; x21 x22 x23; x31 x32 x33] .* K)
        end
        # display(result[2:end-1, 2:end-1])
    end

    return result[2:end-1, 2:end-1]
end


print(("="^10)*"Starting:"*("="^10)*"\n")

f = open("2025\\day04\\puzzle_input.txt", "r")
rolls = readlines(f)

integer_rolls = convert_rolls_to_binary(rolls)
# println("initial rolls: ")
# display(integer_rolls)
convolved_rolls = convolve_rolls(integer_rolls)
masked_rolls = convolved_rolls.*integer_rolls
# println("full scan: ")
# display(masked_rolls)

# Roll out and check if 0<x<5
bin_rolls = 0 .< masked_rolls .< 5
# display(bin_rolls)

nr_free_rolls = sum(vec(bin_rolls))

close(f)

println("Nr of free rolls=$(nr_free_rolls)")
print(("="^10) * "DONE" * ("="^10)*"\n")