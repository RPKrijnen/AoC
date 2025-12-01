#=
You're sure that's the right password, but the door won't open. You knock, but nobody answers. You build a snowman while you think.

As you're rolling the snowballs for your snowman, you find another security document that must have fallen into the snow:

"Due to newer security protocols, please use password method 0x434C49434B until further notice."

You remember from the training seminar that "method 0x434C49434B" means you're actually supposed to count the number of times any click causes the dial to point at 0, regardless of whether it happens during a rotation or at the end of one.

Following the same rotations as in the above example, the dial points at zero a few extra times during its rotations:

    The dial starts by pointing at 50.
    The dial is rotated L68 to point at 82; during this rotation, it points at 0 once.
    The dial is rotated L30 to point at 52.
    The dial is rotated R48 to point at 0.
    The dial is rotated L5 to point at 95.
    The dial is rotated R60 to point at 55; during this rotation, it points at 0 once.
    The dial is rotated L55 to point at 0.
    The dial is rotated L1 to point at 99.
    The dial is rotated L99 to point at 0.
    The dial is rotated R14 to point at 14.
    The dial is rotated L82 to point at 32; during this rotation, it points at 0 once.

In this example, the dial points at 0 three times at the end of a rotation, plus three more times during a rotation. So, in this example, the new password would be 6.

Be careful: if the dial were pointing at 50, a single rotation like R1000 would cause the dial to point at 0 ten times before returning back to 50!

Using password method 0x434C49434B, what is the password to open the door?
=#
print(("="^10)*"Starting:"*("="^10)*"\n")
START_NUMBER = 50
current_number = START_NUMBER
sequence_of_positions = [current_number]
nr_of_zeros = 0
SEQUENCE_OF_ROTATIONS = ["L68",
                        "L30",
                        "R48",
                        "L5",
                        "R60",
                        "L55",
                        "L1",
                        "L99",
                        "R14",
                        "L82",]

function main(lines, current_number, sequence_of_positions, number_of_zeros; verbose::Bool=false)
    part1 = 0
    part2 = 0
    for line in lines
        prev = current_number
        direction = line[1]
        length = parse(Int64, line[2:end])

        direction_mult = 'L' == direction ? -1 : 1
        current_number = current_number + direction_mult*length
        
        incr, current_number = fldmod(current_number, 100)
        if current_number == 0
            part1 += 1
        end
        if incr > 0 && current_number == 0
            incr-=1
        elseif incr < 0 && prev == 0
            incr+=1
        end
        part2 += abs(incr)

        if verbose
            print("current_number: $(current_number), direction: $(direction), direction_mult: $(direction_mult), length: $(length)\n")
        end
        push!(sequence_of_positions, current_number)
    end
    print("Final position: $(current_number), number of zeros part1 : $(part1), number of zeros part2 : $(part1+part2)\n")
    return part2, sequence_of_positions
end

# Sanity check
current_number = 50
nr_of_zeros, sequence_of_positions = main(SEQUENCE_OF_ROTATIONS, current_number, sequence_of_positions, nr_of_zeros, verbose=true)

# True computation
nr_of_zeros = 0
current_number = 50
f = open("puzzle_1_input.txt", "r")
lines = readlines(f)
nr_of_zeros, sequence_of_positions = main(lines, current_number, sequence_of_positions, nr_of_zeros)
close(f)

print(("="^12)*"Done"*("="^13)*"\n")