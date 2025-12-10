package main

import "core:slice"
import "core:sort"
import "core:math"
import "core:fmt"
import "core:strconv"
import "core:strings"

Vec3i :: struct {
    x: i64,
    y: i64,
    z: i64,
}

day_8 :: proc(input_path:string) -> (int, int) {
    // data := read_input_file("test_input")
    data := read_input_file(input_path)
    defer delete(data)
    data_string := string(data)
    
    n := 1000

    lines := strings.split_lines(data_string)
    height := len(lines) - 1
    width := len(lines[0])
    lines = lines[:height] // remove empty string after last line
    
    res1 := 0
    res2 := 0

    points := make([]Vec3i, height)
    defer delete(points)

    circuit_lengths := make([]int, height)
    defer delete(circuit_lengths)

    circuit_map := make(map[Vec3i]^int)
    defer delete(circuit_map)
    
    for line, i in lines {
        point_str := strings.split(line, ",")
        point := Vec3i{}
        point.x, _ = strconv.parse_i64(point_str[0])
        point.y, _ = strconv.parse_i64(point_str[1])
        point.z, _ = strconv.parse_i64(point_str[2])
        
        points[i] = point
    }

    // make assign each point to its own circuit of length 1
    for point, i in points{
        circuit_lengths[i] = 1
        circuit_map[point] = &circuit_lengths[i]
    }
    
    
    PointPair :: struct {
        p1: Vec3i,
        p2: Vec3i
    }

    tmp_pairs := make([]PointPair, len(points)*(len(points)-1))
    defer delete(tmp_pairs)

    pair_id := 0
    
    pair_distance :: proc(p: PointPair) -> i64 {
        return (
            (p.p1.x - p.p2.x) * (p.p1.x - p.p2.x) + 
            (p.p1.y - p.p2.y) * (p.p1.y - p.p2.y) + 
            (p.p1.z - p.p2.z) * (p.p1.z - p.p2.z) 
        )
    }

    // shortest point pairs
    // for point, i in points {
    //     min_point := Vec3i{}
    //     min_distance := max(i64)
    //     for point2, j in points {
    //         if i == j{
    //             continue // don't compare point with itself or with other points in the same circuit
    //         }
    //         // contains := false
    //         // for k in 0..<pair_id {
    //         //     if (tmp_pairs[k].p2 == point && tmp_pairs[k].p1 == point2){
    //         //             contains = true
    //         //     }
    //         // }
    //         // if contains {
    //         //     continue
    //         // }
    //         distance := pair_distance(PointPair{point,point2})
    //         if distance < min_distance {
    //             min_point = point2
    //             min_distance = distance
    //         }
    //     }
    //     if min_point != {0,0,0} {
    //         tmp_pairs[pair_id] = PointPair{point, min_point}
    //         pair_id+=1
    //     }
    // }
    
    for point, i in points {
        for j in i..<len(points) {
            if i == j{
                continue // don't compare point with itself or with other points in the same circuit
            }
            point2 := points[j]
            // contains := false
            // for k in 0..<pair_id {
            //     if (tmp_pairs[k].p2 == point && tmp_pairs[k].p1 == point2){
            //             contains = true
            //             break
            //     }
            // }
            // if contains {
            //     continue
            // }
            tmp_pairs[pair_id] = PointPair{point, point2}
            pair_id+=1
        }
    }
    fmt.println("filled points")


    // bubble sort that shi
    // for i in 1..<pair_id{
    //     for j in 0..<pair_id-i {
    //         if pair_distance(tmp_pairs[j]) > pair_distance(tmp_pairs[j+1]) {
    //             tmp := tmp_pairs[j] 
    //             tmp_pairs[j] = tmp_pairs[j+1]
    //             tmp_pairs[j+1] = tmp
    //         }
    //     }
    // }
    slice.sort_by(tmp_pairs[:pair_id], proc(a, b: PointPair) -> bool {
        return pair_distance(a) < pair_distance(b)
    })

    fmt.println("bubbled and sorted")

    pairs := tmp_pairs[:n]

    // for p in pairs {
    //     fmt.println(p, pair_distance(p))
    // }
    
    i := 0
    for n > 0{
        pair := pairs[i]
        i+=1
        if circuit_map[pair.p2] != circuit_map[pair.p1] {
            circuit_map[pair.p1]^ += circuit_map[pair.p2]^
            ref, _ := circuit_map[pair.p2]
            for k, v in circuit_map {
                if v ==  ref {
                    circuit_map[k] = circuit_map[pair.p1]
                }
            }
            ref^ = 0
        }
        n-=1
    }
    fmt.println("combined circuits")
    // combine pairs into larger circuits
    // for pair, i in point_pairs {
    //     fmt.println(i+1, "st pair <------" )
    //     fmt.println("comparing", pair.p1, pair.p2)
    //     fmt.println("with circuit lengths", circuit_map[pair.p1]^, circuit_map[pair.p2]^)
    //     if circuit_map[pair.p1] == circuit_map[pair.p2]{
    //         fmt.println("skipped because they're part of the same circuit" )
    //         continue
    //     }
    //     circuit_map[pair.p1]^ += circuit_map[pair.p2]^
    //     circuit_map[pair.p2] = circuit_map[pair.p1]
    //     fmt.println("combined into a circuit of length", circuit_map[pair.p1]^)
    // }
    

        
    // can't be bothered to read core::sort docs so we bubble sort dat shit
    // for i in 1..<len(circuit_lengths){
    //     for j in 0..<len(circuit_lengths)-i {
    //         if circuit_lengths[j] < circuit_lengths[j+1] {
    //             tmp := circuit_lengths[j]
    //             circuit_lengths[j] = circuit_lengths[j+1] 
    //             circuit_lengths[j+1] = tmp
    //         }
    //     }
    // }

    slice.sort_by(circuit_lengths[:], proc(a, b: int) -> bool {
        return a > b
    })

    fmt.println("sorted circuit lengths")
    
    fmt.println(circuit_lengths[0], circuit_lengths[1], circuit_lengths[2])
    res1 = circuit_lengths[0] * circuit_lengths[1] * circuit_lengths[2]
    return res1, res2
}
