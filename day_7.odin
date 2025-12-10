package main

import "core:fmt"
import "core:strconv"
import "core:strings"

Point :: struct {
    x:int,
    y:int
}

simulate_beam :: proc(grid: ^[]string, x, y : int) -> int{
    if x < 0 || x >= len(grid[0]) || grid[y][x] == '|'  || y >= len(grid){
        return 0
    }

    // fmt.println(x,y, len(grid), len(grid[0]))
    for i in y..<len(grid) {
        // fmt.println("len: ", len(grid[i]))
        if grid[i][x] == '^' {
            return simulate_beam(grid, x-1, i) + simulate_beam(grid, x+1, i)
        }
        // getting a mutable view into grid
        buffer := transmute([]u8)grid[i]
        buffer[x] = '|'
    }
    // fmt.println(x, y)
    return 1
}
simulate_beam_timeline :: proc(grid: ^[]string, cache: ^map[Point]int, x, y : int) -> int{
    if x < 0 || x >= len(grid[0]) || y >= len(grid){
        return 0
    }

    // fmt.println(x,y, len(grid), len(grid[0]))
    for i in y..<len(grid) {
        // fmt.println("len: ", len(grid[i]))
        if grid[i][x] != '^' {
            continue
        }
        if val, ok := cache[{x,i}]; !ok {
           cache[{x,i}] = simulate_beam_timeline(grid, cache, x-1, i) + simulate_beam_timeline(grid, cache, x+1, i)
        }
        return cache[{x,i}]
    }
    return 1
}
day_7 :: proc(input_path:string) -> (int, int) {
    // data := read_input_file("test_input")
    data := read_input_file(input_path)
    defer delete(data)
    data_string := string(data)
    
    lines := strings.split_lines(data_string)
    height := len(lines) - 1
    width := len(lines[0])
    lines = lines[:height] // remove empty string after last line
    
    start_x := width/2
    res1 := 0

    split_sum := simulate_beam(&lines, start_x, 0)
    // res1 = split_sum
    for l, y in lines {
        for c, x in l {
            if c == '^' && lines[y-1][x] == '|' {
                res1 += 1
            }
        }
    }   
    res2 := 0
    // tmp_sum := 0
    // for l, y in lines {
    //     tmp_sum := 0
    //     for c, x in l {
    //         if c == '^' && lines[y-1][x] == '|' {
    //             tmp_sum += 1
    //         }
    //     }
    //     if tmp_sum != 0 {
    //         res2 += 2 * tmp_sum
    //         fmt.println(2 * tmp_sum)
    //     }
    // }   
    cache := make(map[Point]int)
    defer delete(cache)
    res2 = simulate_beam_timeline(&lines, &cache, width/2, 0)

    return res1, res2
}
