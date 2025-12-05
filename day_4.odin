package main

import "core:math"
import "core:fmt"
import "core:strconv"
import "core:strings"
import "core:os"

directions :: struct {
    N:bool,
    NE:bool,
    E:bool,
    SE:bool,
    S:bool,
    SW:bool,
    W:bool,
    NW:bool
}

get_dirs :: proc(x: int, y: int, width: int, height: int) -> directions {
    dirs := directions{true, true, true, true, true, true, true, true}
    if x == 0 {
        dirs.NW = false
        dirs.W = false
        dirs.SW = false
    }else if x == width-1 {
        dirs.NE = false
        dirs.E = false
        dirs.SE = false
    }
    if y == 0 {
        dirs.NW = false
        dirs.N = false
        dirs.NE = false
    } else if y == height-1 {
        dirs.SW = false
        dirs.S = false
        dirs.SE = false
    }

    return dirs
}

count_neighbours :: proc(grid: []string, x: int, y: int, width: int, height: int) -> int {
    dirs := get_dirs(x, y, width, height)
    sum := 0
    if dirs.N {
        sum += grid[y-1][x] == '@'
    }
    if dirs.NE {
        sum += grid[y-1][x+1] == '@'
    }
    if dirs.E {
        sum += grid[y][x+1] == '@'
    }
    if dirs.SE {
        sum += grid[y+1][x+1] == '@'
    }
    if dirs.S {
        sum += grid[y+1][x] == '@'
    }
    if dirs.SW {
        sum += grid[y+1][x-1] == '@'
    }
    if dirs.W {
        sum += grid[y][x-1] == '@'
    }
    if dirs.NW {
        sum += grid[y-1][x-1] == '@'
    }
    return sum
}

day_4 :: proc(input_path:string) -> (int, int) {
    data := read_input_file(input_path)
    defer delete(data)
    data_string := string(data)
    lines := strings.split_lines(data_string)
    height := len(lines)-1
    width := len(lines[0])
    
    fmt.printfln("width: %d, height: %d ", width, height)
    // part 1
    y := 0
    sum1 := 0
    for &line in lines {
        x := 0
        for c in line {
            if c != '@' {
                x += 1
                continue
            }
            if count_neighbours(lines, x, y, width, height) < 4 {
                sum1 += 1
                
            }else {
            }
            x+=1
        }
        y+=1
    }

    // part 2
    i := 0
    removed_sum := 0
    removed := -1
    for removed != 0 {
        y := 0
        removed = 0
        for &line in lines {
            x := 0
            for c in line {
                if c != '@' {
                    x += 1
                    continue
                }
                if count_neighbours(lines, x, y, width, height) < 4 {
                    s_slice := transmute([]u8)line
                    s_slice[x] = '.'
                    removed += 1

                }
                x+=1
            }
            y+=1
        }
        removed_sum += removed
    }

    return sum1, removed_sum
}
