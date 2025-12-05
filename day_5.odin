package main

import "core:fmt"
import "core:math"
import "core:strconv"
import "core:strings"

range :: struct {
    start: int,
    end: int,
}

nil_range :: range {-1, -1}

day_5 :: proc(input_path:string) -> (int, int) {
    data := read_input_file(input_path)
    defer delete(data)
    data_string := string(data)
    
    lines := strings.split_lines(data_string)
    line_count := len(lines) - 1 // accounting for additional empty string after last \n
    break_index := -1
    for l, i in lines[:line_count] {
        if l == "" {
            break_index = i
        }
    }
    ranges_str := lines[:break_index]
    ids := lines[break_index+1:]
    
    // turn string ranges into a type that's easier to work with
    ranges := make([]range, break_index)
    for line, i in ranges_str{
        split_str := strings.split(line, "-")
        start_val, _ := strconv.parse_int(split_str[0])
        end_val, _ := strconv.parse_int(split_str[1])

        ranges[i] = {
            start = start_val,
            end = end_val
        }
    }

    // Part 1
    // count all ids that are inside provided ranges
    res1 := 0
    id_loop:
    for id_str in ids {
        id, _ := strconv.parse_int(id_str)
        for r in ranges {
            if id >= r.start && id <= r.end {
                res1 += 1
                continue id_loop
            }
        }
    }

    // Part 2
    // count all possible ids included in provided ranges

    // attempt 1 - brute force (takes forever to run)
    // find minimal lower bound and maximal upper bound for all ranges and check all ids between them
    
    // sum2 := 0
    // ranges_min := ranges[0].start
    // ranges_max := ranges[0].end
    // for r in ranges {
    //     if r.start < ranges_min {
    //         ranges_min = r.start
    //     }
    //     if r.end > ranges_max {
    //         ranges_max = r.end
    //     }
    // }

    // for id in ranges_min..=ranges_max {
    //     if id >= ranges_min && id <= ranges_max {
    //         sum2 += 1
    //         continue
    //     }
    // }
   
    // attempt 2 - combine overlappnig ranges (way better)
    
    res2 := 0

    // iterate over all ranges and combine those that overlap
    for r, i in ranges[:len(ranges)-1] {
        if r == nil_range {
            continue
        }
        for j in (i+1)..<len(ranges) {
            r2 := ranges[j]
            if r2 == nil_range {
                continue
            }
            if r2.start >= r.start && r2.end <= r.end { // r fully encompasses r2 so we can ignore it
                ranges[j] = r
                ranges[i] = nil_range
            }else if r2.start <= r.start && r2.end >= r.end { // r2 fully encompasses r so we can assign it to r and set r2 to null value
                ranges[i] = nil_range 
            }else if r2.start < r.start && r2.end >= r.start && r2.end <= r.end{ // r2 has wider reach to the left
                ranges[j] = {r2.start, r.end}
                ranges[i] = nil_range 
            }else if r2.end > r.end && r2.start >= r.start && r2.start <= r.end{ // r2 has wider reach to the right
                ranges[j] = {r.start, r2.end}
                ranges[i] = nil_range
            }
        }
    }
    for r in ranges {
        if r == nil_range {
            continue
        }
        res2 += (r.end - r.start) + 1 // count all numbers covered by this range
    }

    return res1, res2
}
