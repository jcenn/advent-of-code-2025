package main

import "core:strconv"
import "core:strings"

day_6 :: proc(input_path:string) -> (int, int) {
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
    // part 2
    // todo: iterate over the last line (operators), empty column is always right in front of operator 
    // so we can fill array columns with string slices like line[last_op_index:next_op_index] and then iterate vertically to turn them into numbers
    //fmt.println(nums)
    res2 := 0
    builder := strings.builder_make()
    defer strings.builder_destroy(&builder)

    start_index := 0
    end_index := 0
    for i in 1..<len(lines[0]) {
        //fmt.println("xd")
        // when we find * or +
        if lines[height][i] != ' ' {
            operator := lines[height][start_index]
            end_index = i-1
            tmp_res := 0
            max_digits := end_index - start_index

            if operator == '*' {
                tmp_res = 1
            }
            
            for j in 0..<max_digits {
                strings.builder_reset(&builder)
                for y in 0..<height {
                    c := lines[y][j+start_index]
                    if c == ' ' {
                        continue
                    }
                    strings.write_byte(&builder, c)
                }
                n, _ := strconv.parse_int(strings.to_string(builder), 10)
                if operator == '+' {
                    tmp_res += n
                } else if operator == '*' {
                    tmp_res *= n
                }
            }
            res2 += tmp_res

            start_index = end_index + 1
        }

        if i == len(lines[0]) - 1 {
            operator := lines[height][start_index]
            end_index =len(lines[0]) 
            tmp_res := 0
            max_digits := end_index - start_index

            if operator == '*' {
                tmp_res = 1
            }
            
            for j in 0..<max_digits {
                strings.builder_reset(&builder)
                for y in 0..<height {
                    c := lines[y][j+start_index]
                    if c == ' ' {
                        continue
                    }
                    strings.write_byte(&builder, c)
                }
                n, _ := strconv.parse_int(strings.to_string(builder), 10)
                if operator == '+' {
                    tmp_res += n
                } else if operator == '*' {
                    tmp_res *= n
                }
            }
            res2 += tmp_res
        }
    }


    return res1, res2
}
