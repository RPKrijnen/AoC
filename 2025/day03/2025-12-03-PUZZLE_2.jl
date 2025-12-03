#=
--- Day 3: Lobby ---

You descend a short staircase, enter the surprisingly vast lobby, and are quickly cleared by the security checkpoint. When you get to the main elevators, however, you discover that each one has a red light above it: they're all offline.

"Sorry about that," an Elf apologizes as she tinkers with a nearby control panel. "Some kind of electrical surge seems to have fried them. I'll try to get them online soon."

You explain your need to get further underground. "Well, you could at least take the escalator down to the printing department, not that you'd get much further than that without the elevators working. That is, you could if the escalator weren't also offline."

"But, don't worry! It's not fried; it just needs power. Maybe you can get it running while I keep working on the elevators."

There are batteries nearby that can supply emergency power to the escalator for just such an occasion. The batteries are each labeled with their joltage rating, a value from 1 to 9. You make a note of their joltage ratings (your puzzle input). For example:

987654321111111
811111111111119
234234234234278
818181911112111

The batteries are arranged into banks; each line of digits in your input corresponds to a single bank of batteries. Within each bank, you need to turn on exactly two batteries; the joltage that the bank produces is equal to the number formed by the digits on the batteries you've turned on. For example, if you have a bank like 12345 and you turn on batteries 2 and 4, the bank would produce 24 jolts. (You cannot rearrange batteries.)

You'll need to find the largest possible joltage each bank can produce. In the above example:

    In 987654321111111, you can make the largest joltage possible, 98, by turning on the first two batteries.
    In 811111111111119, you can make the largest joltage possible by turning on the batteries labeled 8 and 9, producing 89 jolts.
    In 234234234234278, you can make 78 by turning on the last two batteries (marked 7 and 8).
    In 818181911112111, the largest joltage you can produce is 92.

The total output joltage is the sum of the maximum joltage from each bank, so in this example, the total output joltage is 98 + 89 + 78 + 92 = 357.

There are many batteries in front of you. Find the maximum joltage possible from each bank; what is the total output joltage?

Your puzzle answer was 17405.

The first half of this puzzle is complete! It provides one gold star: *
--- Part Two ---

The escalator doesn't move. The Elf explains that it probably needs more joltage to overcome the static friction of the system and hits the big red "joltage limit safety override" button. You lose count of the number of times she needs to confirm "yes, I'm sure" and decorate the lobby a bit while you wait.

Now, you need to make the largest joltage by turning on exactly twelve batteries within each bank.

The joltage output for the bank is still the number formed by the digits of the batteries you've turned on; the only difference is that now there will be 12 digits in each bank's joltage output instead of two.

Consider again the example from before:

987654321111111
811111111111119
234234234234278
818181911112111

Now, the joltages are much larger:

    In 987654321111111, the largest joltage can be found by turning on everything except some 1s at the end to produce 987654321111.
    In the digit sequence 811111111111119, the largest joltage can be found by turning on everything except some 1s, producing 811111111119.
    In 234234234234278, the largest joltage can be found by turning on everything except a 2 battery, a 3 battery, and another 2 battery near the start to produce 434234234278.
    In 818181911112111, the joltage 888911112111 is produced by turning on everything except some 1s near the front.

The total output joltage is now much larger: 987654321111 + 811111111119 + 434234234278 + 888911112111 = 3121910778619.

What is the new total output joltage? 171990312704598

=#


function main(banks; nr_consecutive::Int=2)
    index_array = [0]
    bank_voltage = 0
    for bank in banks
        # Convert line of batteries in string form to array of integers
        bank_array = [parse(Int, ss) for ss in collect(bank)]

        # Now it's a matter of finding a string of twelve consecutive numbers in the sorted_bank_index
        function find_next_battery(index_array, subbank_array, nr_to_go)
            # sort the array to just get the first indices and gtfo
            sorted_bank_index = sortperm(subbank_array, rev=true)
            for idx in collect(1:length(subbank_array))
                if sorted_bank_index[idx] < length(subbank_array) - nr_to_go + 2
                    push!(index_array, sorted_bank_index[idx]+index_array[end])
                    break
                end
            end
            return index_array
        end

        subbank_array = bank_array
        for jdx in collect(1:nr_consecutive)
            index_array = find_next_battery(index_array, subbank_array, nr_consecutive-jdx+1)
            subbank_array = bank_array[index_array[end]+1:end]
        end

        # pop to remove 0 entry before post_processing
        popfirst!(index_array)

        string_of_batteries = [string(bank_array[index]) for index in index_array]
        best_batteries = join(string_of_batteries)
        println("Best batteries: $(best_batteries)")
        
        bank_voltage += parse(Int, best_batteries)
        index_array = [0]
    end
    return bank_voltage
end



print(("="^10)*"Starting:"*("="^10)*"\n")

f = open("2025\\day03\\puzzle_input.txt", "r")
banks = readlines(f)
final_bank_voltage = main(banks, nr_consecutive=12)
close(f)

println("Final bank voltage=$(final_bank_voltage)")
print(("="^10) * "DONE" * ("="^10)*"\n")