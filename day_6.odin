package main

import "core:fmt"
import "core:strconv"
import "core:strings"

day_6 :: proc(input_path:string) -> (int, int) {
    // data := read_input_file("test_input")
    data := read_input_file(input_path)
    defer delete(data)
    data_string := string(data)
    
    lines := strings.split_lines(data_string)
    width := 0
    for s in strings.split(lines[0], " "){
        if s == "" {
            continue
        }
        width += 1
    }

    height := len(lines) - 2
    nums := make([][]int, height)
    for _, i in nums {
        nums[i] = make([]int, width)
    }

    for line, y in lines[:height] {
        x := 0
        for s in strings.split(line, " ") {
            if s == "" {
                continue
            }
            val, _ := strconv.parse_int(s, 10)
            nums[y][x] = val
            x += 1
        }
    }
    results := make([]int, width)
    defer delete(results)

    res1 := 0

    i := 0
    for op in strings.split(lines[height], " ") {
        if op == "" {
            continue
        }

        res := 0
        if op == "+" {
            for y in 0..<height {
                res += nums[y][i]
            }
        }else if op == "*" {
            res = 1
            for y in 0..<height {
                res *= nums[y][i]
            }
        }
        results[i] = res
        res1 += res
        i += 1
    }
    

    //fmt.println(nums)

    res2 := 0
    return res1, res2
}
