package main

import "core:container/queue"
import "core:fmt"
import "core:strings"

day_11 :: proc(input_path:string) -> (int, int) {
    // data := read_input_file("test_input")
    data := read_input_file(input_path)
    defer delete(data)
    data_string := string(data)
    
    lines := strings.split_lines(data_string)
    height := len(lines) - 1
    lines = lines[:height] // remove empty string after last line

    res1 := 0 
    fmt.println("solved part 1")

    fmt.println("solved second variant of part 2")
    res2 := 0 

    return res1, res2
}
