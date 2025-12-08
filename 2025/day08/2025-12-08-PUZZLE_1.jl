#=
--- Day 8: Playground ---
Equipped with a new understanding of teleporter maintenance, you confidently step onto the repaired teleporter pad.

You rematerialize on an unfamiliar teleporter pad and find yourself in a vast underground space which contains a giant playground!

Across the playground, a group of Elves are working on setting up an ambitious Christmas decoration project. Through careful rigging, they have suspended a large number of small electrical junction boxes.

Their plan is to connect the junction boxes with long strings of lights. Most of the junction boxes don't provide electricity; however, when two junction boxes are connected by a string of lights, electricity can pass between those two junction boxes.

The Elves are trying to figure out which junction boxes to connect so that electricity can reach every junction box. They even have a list of all of the junction boxes' positions in 3D space (your puzzle input).

For example:

162,817,812
57,618,57
906,360,560
592,479,940
352,342,300
466,668,158
542,29,236
431,825,988
739,650,466
52,470,668
216,146,977
819,987,18
117,168,530
805,96,715
346,949,466
970,615,88
941,993,340
862,61,35
984,92,344
425,690,689
This list describes the position of 20 junction boxes, one per line. Each position is given as X,Y,Z coordinates. So, the first junction box in the list is at X=162, Y=817, Z=812.

To save on string lights, the Elves would like to focus on connecting pairs of junction boxes that are as close together as possible according to straight-line distance. In this example, the two junction boxes which are closest together are 162,817,812 and 425,690,689.

By connecting these two junction boxes together, because electricity can flow between them, they become part of the same circuit. After connecting them, there is a single circuit which contains two junction boxes, and the remaining 18 junction boxes remain in their own individual circuits.

Now, the two junction boxes which are closest together but aren't already directly connected are 162,817,812 and 431,825,988. After connecting them, since 162,817,812 is already connected to another junction box, there is now a single circuit which contains three junction boxes and an additional 17 circuits which contain one junction box each.

The next two junction boxes to connect are 906,360,560 and 805,96,715. After connecting them, there is a circuit containing 3 junction boxes, a circuit containing 2 junction boxes, and 15 circuits which contain one junction box each.

The next two junction boxes are 431,825,988 and 425,690,689. Because these two junction boxes were already in the same circuit, nothing happens!

This process continues for a while, and the Elves are concerned that they don't have enough extension cables for all these circuits. They would like to know how big the circuits will be.

After making the ten shortest connections, there are 11 circuits: one circuit which contains 5 junction boxes, one circuit which contains 4 junction boxes, two circuits which contain 2 junction boxes each, and seven circuits which each contain a single junction box. Multiplying together the sizes of the three largest circuits (5, 4, and one of the circuits of size 2) produces 40.

Your list contains many junction boxes; connect together the 1000 pairs of junction boxes which are closest together. Afterward, what do you get if you multiply together the sizes of the three largest circuits?
=#

import Pkg; Pkg.add("CSV")
import LinearAlgebra
using CSV
using DataFrames


function L2_distance(a, b)
    return LinearAlgebra.norm(a-b, 2)
end


function main(df; N=1000)
    res = 0
    n_rows = nrow(df)
    covariance = zeros((n_rows, n_rows))

    points = []
    for (idx, point1) in enumerate(eachrow(df))
        point1 = convert(Array, [point1["x"], point1["y"], point1["z"]])
        for jdx in collect(idx+1:n_rows)#(jdx, point2) in enumerate(eachrow(df))
            point2 = df[jdx, :]
            point2 = convert(Array, [point2["x"], point2["y"], point2["z"]])
            # println(data)
            distance = L2_distance(convert(Array, point1), convert(Array, point2))
            covariance[idx, jdx] = distance
            push!(points, [distance, idx, jdx])
        end
    end
    sort!(points)
    # println("Calculated covariance")

    parent = collect(1:n_rows)
    size = ones(n_rows)

    function find(x)
        while x != parent[x]
            x = parent[x]
        end
        # println("found x: $(x)")
        return x
    end

    function custom_union(a, b)
        a, b = find(a), find(b)
        if a == b
            return 0
        end
        parent[b] = a
        size[a] += size[b]
        return size[a]
    end

    # println(points[21:2+N])

    for (_, a, b) in points[1:N]
        custom_union(convert(Int, a), convert(Int, b))
    end

    # println("unionized")

    # println("n: $(n), size: $(size)")
    sizes = [size[i] for i in collect(1:n_rows) if i == parent[i]]
    sizes = sort(sizes)
    # println("n: $(n), size: $(sizes)")
    println("Part 1 :, $(convert(Int, sizes[end]*sizes[end-1]*sizes[end-2]))")

    parent = collect(1:n_rows)
    size = ones(n_rows)
    k = 1

    function connect_all()
        a = 0
        b = 0
        while true
            _, a, b = points[k]
            # println("wow a: $(convert(Int, a)), b $(convert(Int, b))")
            if custom_union(convert(Int, a), convert(Int, b)) == n_rows
                break
            end
            k += 1
        end

        # print(" index a: $(a), b: $(b)")
        x1 = df[!, "x"][convert(Int, a)]
        x2 = df[!, "x"][convert(Int, b)]
        println("Part 2 : $(x1*x2)")
    end
    connect_all()

    return res
end

print(("="^10)*"Starting:"*("="^10)*"\n")
final_answer = 0
df = CSV.read("2025\\day08\\puzzle_input.csv", DataFrame; delim=",", ignorerepeated=true, types=Int, validate=false)
nr_of_elements = size(df)
# println(df)

final_answer = main(df)
# close(f)

# println("Final answer=$(final_answer)")
print(("="^10) * "DONE" * ("="^10)*"\n")

#=
This one was very hard.
I did not know about the findunion algorithm and I still don't fully understand it...
=#