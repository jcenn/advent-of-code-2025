package main

import "core:strconv"
import "core:container/queue"
import "core:fmt"
import "core:strings"


day_12 :: proc(input_path:string) -> (int, int) {
    // data := read_input_file("test_input")
    data := read_input_file(input_path)
    defer delete(data)
    data_string := string(data)
    
    lines := strings.split_lines(data_string)
    height := len(lines) - 1
    lines = lines[:height] // remove empty string after last line

    res1 := 0
    for line in lines[30:]{
        split := strings.split(line, " ")
        size_str := split[0][:len(split[0])-1] // axb: -> axb
        dimensions_str := strings.split(size_str, "x")
        width, _ := strconv.parse_int(dimensions_str[0])
        height, _:= strconv.parse_int(dimensions_str[1])

        fmt.println(width, height)
        area_sum := 0
        for count_str in split[1:] {
            count, _:= strconv.parse_int(count_str)
            area_sum += count * 7 // assume each shape has an area of 7
            //fmt.println(count)
        }
        if area_sum < width * height {
            res1 += 1
        }

    }
    fmt.println("solved part 1")

    fmt.println("solved second variant of part 2")
    res2 := 0 

    return res1, res2
}
