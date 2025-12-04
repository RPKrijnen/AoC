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

1372


--- Part Two ---

Now, the Elves just need help accessing as much of the paper as they can.

Once a roll of paper can be accessed by a forklift, it can be removed. Once a roll of paper is removed, the forklifts might be able to access more rolls of paper, which they might also be able to remove. How many total rolls of paper could the Elves remove if they keep repeating this process?

Starting with the same example as above, here is one way you could remove as many rolls of paper as possible, using highlighted @ to indicate that a roll of paper is about to be removed, and using x to indicate that a roll of paper was just removed:

Initial state:
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

Remove 13 rolls of paper:
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

Remove 12 rolls of paper:
.......x..
.@@.x.x.@x
x@@@@...@@
x.@@@@..x.
.@.@@@@.x.
.x@@@@@@.x
.x.@.@.@@@
..@@@.@@@@
.x@@@@@@@.
....@@@...

Remove 7 rolls of paper:
..........
.x@.....x.
.@@@@...xx
..@@@@....
.x.@@@@...
..@@@@@@..
...@.@.@@x
..@@@.@@@@
..x@@@@@@.
....@@@...

Remove 5 rolls of paper:
..........
..x.......
.x@@@.....
..@@@@....
...@@@@...
..x@@@@@..
...@.@.@@.
..x@@.@@@x
...@@@@@@.
....@@@...

Remove 2 rolls of paper:
..........
..........
..x@@.....
..@@@@....
...@@@@...
...@@@@@..
...@.@.@@.
...@@.@@@.
...@@@@@x.
....@@@...

Remove 1 roll of paper:
..........
..........
...@@.....
..x@@@....
...@@@@...
...@@@@@..
...@.@.@@.
...@@.@@@.
...@@@@@..
....@@@...

Remove 1 roll of paper:
..........
..........
...x@.....
...@@@....
...@@@@...
...@@@@@..
...@.@.@@.
...@@.@@@.
...@@@@@..
....@@@...

Remove 1 roll of paper:
..........
..........
....x.....
...@@@....
...@@@@...
...@@@@@..
...@.@.@@.
...@@.@@@.
...@@@@@..
....@@@...

Remove 1 roll of paper:
..........
..........
..........
...x@@....
...@@@@...
...@@@@@..
...@.@.@@.
...@@.@@@.
...@@@@@..
....@@@...

Stop once no more rolls of paper are accessible by a forklift. In this example, a total of 43 rolls of paper can be removed.

Start with your original diagram. How many rolls of paper in total can be removed by the Elves and their forklifts?


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


function remove_rolls(rolls)
    nr_removed_rolls = 0
    prev = 0
    updated_rolls = rolls
    for index in 1:prod(size(rolls))
        convolved_rolls = convolve_rolls(updated_rolls)
        masked_rolls = convolved_rolls.*updated_rolls

        bin_rolls = 0 .< masked_rolls .< 5
        updated_rolls = .~bin_rolls .* updated_rolls

        nr_removed_rolls += sum(vec(bin_rolls))
        
        if prev == nr_removed_rolls
            break
        else
            prev = nr_removed_rolls 
        end
    end
    return nr_removed_rolls
end

print(("="^10)*"Starting:"*("="^10)*"\n")

f = open("2025\\day04\\puzzle_input.txt", "r")
rolls = readlines(f)

integer_rolls = convert_rolls_to_binary(rolls)
nr_removed_rolls = remove_rolls(integer_rolls)
close(f)

println("Nr of removed rolls=$(nr_removed_rolls)")
print(("="^10) * "DONE" * ("="^10)*"\n")