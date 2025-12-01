package main

import "core:strconv"
import "core:strings"
import "core:os"

// count how many times dial lands at 0
day_1 :: proc() -> int{
    path :: "input_day_1.txt"
    data, ok := os.read_entire_file(path)
    if !ok{
        panic_contextless("couldn't read provided file: " + path)
    }
    defer delete(data)
    data_string := string(data)

    zero_count := 0

    dial := 50
    for line in strings.split_lines_iterator(&data_string){
        sign := 1
        if line[0] == 'L'{
            sign = -1
        }

        n, _ := strconv.parse_int(line[1:], 10)
        n *= sign
        dial += n
        dial %= 100
        
        if dial == 0{
            zero_count += 1
        }
    }
    return zero_count
}

// count how many times dial goes through 0
day_1_p2 :: proc() -> int{
    path :: "input_day_1.txt"
    data, ok := os.read_entire_file(path)
    if !ok{
        panic_contextless("couldn't read provided file: " + path)
    }
    defer delete(data)
    data_string := string(data)

    zero_count := 0

    dial := 50
    for line in strings.split_lines_iterator(&data_string){
        sign := 1
        if line[0] == 'L'{
            sign = -1
        }

        n, _ := strconv.parse_int(line[1:], 10)
        rots := n/100 // full rotations
        zero_count += rots
        n -= rots * 100
        n *= sign

        old_dial := dial
        dial += n
    
        // overflow when going right
        if dial > 100{
            dial -= 100
            zero_count += 1
        }

        // overflow when going left (have to exclude edge case where we start at 0 and go left)
        if dial < 0{
            dial += 100
            if old_dial != 0{
                zero_count += 1
            }
        }

        dial %= 100 // when dial == 100
        if dial == 0 { 
            zero_count += 1
        }
    }
    return zero_count
}