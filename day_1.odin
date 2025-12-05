package main

import "core:strconv"
import "core:strings"
import "core:os"

// count how many times dial lands at 0
day_1 :: proc(input_path:string) -> (int, int) {
    data := read_input_file(input_path)
    defer delete(data)
    data_string := string(data)

    p1_count := 0
    p2_count := 0

    dial := 50
    for line in strings.split_lines_iterator(&data_string){
        sign := 1
        if line[0] == 'L'{
            sign = -1
        }

        n, _ := strconv.parse_int(line[1:], 10)
        rots := n/100 // full rotations
        p2_count += rots
        n -= rots * 100
        
        n *= sign
        old_dial := dial
        dial += n
        
        // overflow when going right
        if dial > 100{
            dial -= 100
            p2_count += 1
        }

        // overflow when going left (have to exclude edge case where we start at 0 and go left)
        if dial < 0{
            dial += 100
            if old_dial != 0{
                p2_count += 1
            }
        }
        dial %= 100
        
        if dial == 0{
            p1_count += 1
        }

    }
    return p1_count, p1_count + p2_count
}
