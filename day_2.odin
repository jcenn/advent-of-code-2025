
package main

import "core:math"
import "core:fmt"
import "core:strconv"
import "core:strings"
import "core:os"

day_2 :: proc() -> int{
    path :: "input_day_2.txt"
    data, ok := os.read_entire_file(path)
    if !ok{
        panic_contextless("couldn't read provided file: " + path)
    }
    defer delete(data)
    data_string := string(data)

    sum := 0
    for num_range in strings.split_iterator(&data_string, ","){
        range_separated := strings.split(num_range, "-")
        lower, _ := strconv.parse_int(range_separated[0])
        upper, _ := strconv.parse_int(range_separated[1])

        for n in lower..=upper{
            digits:int = int(math.floor(math.log10(f32(n)))) + 1
            // if n has odd number of digits it cannot contain duplicated pattern so we can skip it
            if digits % 2 == 1 { 
                continue
            }
            
            upper_n := n/int(math.pow10(f32(digits/2)))
            lower_n := n - upper_n * int(math.pow10(f32(digits/2)))
            if lower_n == upper_n {
                sum += n
            }
        }
    }
    return sum
}

day_2_p2 :: proc() -> int{
    return 0
}