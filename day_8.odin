package main

import "core:slice"
import "core:fmt"
import "core:strconv"
import "core:strings"

Vec3i :: struct {
    x: i64,
    y: i64,
    z: i64,
}

day_8 :: proc(input_path:string) -> (int, int) {
    data := read_input_file(input_path)
    defer delete(data)
    data_string := string(data)
    
    n := 1000

    lines := strings.split_lines(data_string)
    height := len(lines) - 1
    width := len(lines[0])
    lines = lines[:height] // remove empty string after last line
    
    res1 := 0
    res2 := int(0)

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
    
    for point, i in points {
        for j in i..<len(points) {
            if i == j{
                continue // don't compare point with itself or with other points in the same circuit
            }
            point2 := points[j]
            tmp_pairs[pair_id] = PointPair{point, point2}
            pair_id+=1
        }
    }

    slice.sort_by(tmp_pairs[:pair_id], proc(a, b: PointPair) -> bool {
        return pair_distance(a) < pair_distance(b)
    })


    // solving part 2
    pairs := tmp_pairs[:]
    tmp_map := make(map[Vec3i]^int)
    defer delete(tmp_map)
    for k, v in circuit_map {
        tmp_map[k] = v
    }
    i := 0
    last_pair := PointPair{}
    for pair in pairs{
        if tmp_map[pair.p2] != tmp_map[pair.p1] {
            last_pair = pair
            ref, _ := tmp_map[pair.p2]
            for k, v in tmp_map {
                if v ==  ref {
                    tmp_map[k] = tmp_map[pair.p1]
                }
            }
        }
    }

    res2 = int(last_pair.p1.x * last_pair.p2.x)


    // solving part 1
    pairs = tmp_pairs[:n]

    i = 0
    for pair in pairs{
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
    }
    slice.sort_by(circuit_lengths[:], proc(a, b: int) -> bool {
        return a > b
    })
    
    res1 = circuit_lengths[0] * circuit_lengths[1] * circuit_lengths[2]

    
    
    return res1, res2
}
