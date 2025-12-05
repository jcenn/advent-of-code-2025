package main

import "core:strings"

find_largest_number :: proc(s: string, battery_count: int) -> int {
    max_sum := 0
    max := 0
    max_index := -1
    for k := battery_count-1; k >=0; k-=1{
        max = 0
        for i in (max_index + 1)..<(len(s)-k){
            n := int(s[i] - '0') // ascii -> int digit conversion
            if n > max {
                max = n
                max_index = i;
            }
        }
        if max == 0 {
            max_index += 1
            max = int(s[max_index] - '0')
        }
        max_sum *= 10
        max_sum += max
    }
    return max_sum
}

day_3 :: proc(input_path:string) -> (int, int) {
    data := read_input_file(input_path)
    defer delete(data)
    data_string := string(data)
    two_sum := 0
    twelve_sum := 0
    for line in strings.split_lines_iterator(&data_string){
        two_sum += find_largest_number(line, 2)
        twelve_sum += find_largest_number(line, 12)
    }

    return two_sum, twelve_sum
}
