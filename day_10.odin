package main

import "core:container/queue"
import "core:slice"
import "core:strconv"
import "core:fmt"
import "core:strings"

day_10 :: proc(input_path:string) -> (int, int) {
    // data := read_input_file("test_input")
    data := read_input_file(input_path)
    defer delete(data)
    data_string := string(data)
    
    lines := strings.split_lines(data_string)
    height := len(lines) - 1
    lines = lines[:height] // remove empty string after last line
    
    res1 := 0
        
    get_xor_count :: proc(target: uint, masks: []uint, current_count: uint) -> uint{
        if len(masks) == 0 {
            return 0
        }
        min_count := max(uint)
        // first iterate to check if any mask matches
        for m in masks {
            if target~m == 0{
                return current_count + 1
            }
        }
        // if none matched start recursively iterating over others
        for m, i in masks {
            new_masks := slice.concatenate([][]uint{ masks[:i], masks[i+1:] })
            defer delete(new_masks)

            count := get_xor_count(target~m, new_masks, current_count+1)
            if count != 0 && count < min_count{
                min_count = count
            }
        }
        return min_count
    }

    for line, ln in lines {
        fmt.printfln("line %d/%d", ln, height)
        split := strings.split(line, " ")
        
        target := split[0][1:len(split[0])-1] // skip first and last characters ('[',']')
        bytes := transmute([]byte)target
        for i in 0..<len(target){
            if bytes[i] == '.'{
                bytes[i] = '0'
            }
            if bytes[i] == '#'{
                bytes[i] = '1'
            }
        }
        // fmt.printfln("target: %s", target)

        bitmasks := make([]uint, len(split)-2)
        defer delete(bitmasks)

        for i in 1..<len(split)-1 {
            num_str := strings.split(split[i][1:len(split[i])-1], ",") // turn "(1,2,3)" into ["1","2","3"]
            bitmask := uint(0)
            word_length := len(target)
            for n in num_str {
                n_val, _ := strconv.parse_int(n)
                bitmask |= 1 << uint(word_length-n_val -1)
            }

            bitmasks[i-1] = bitmask
        }

        // can speed up by iterating over masks and 

        // for mask in bitmasks {
        //     format_str := []u8{'%',u8(len(target))+'0','b',0}
        //     fmt.printfln(transmute(string)format_str, mask)
        // }
        target_bits, _ := strconv.parse_uint(target, 2)
        q: queue.Queue(uint)
        
        queue.init(&q)
        defer queue.destroy(&q)
        
        count_map := make(map[uint]uint)
        defer delete(count_map)

        queue.push_back(&q, target_bits)
        count_map[target_bits] = 0
        min_count := uint(0)

        min_loop:
        for min_count == 0 {
            n := queue.pop_front(&q)
            for m in bitmasks {
                tmp_count, ok := count_map[m~n]
                n_count, _ := count_map[n] // update lengths kinda like in Dijkstra
                if ok && n_count+1 < tmp_count {
                    count_map[m~n] = n_count + 1
                }
                if !ok {
                    if m~n == 0 {
                        min_count = n_count + 1
                        break min_loop
                    }
                    count_map[m~n] = n_count + 1
                    queue.push_back(&q, m~n)
                }

            }
        }
        
        //count := get_xor_count(target_bits, bitmasks, 0)
        //fmt.println("count: ", min_count)
        res1 += int(min_count)
    }

    res2 := 0

    return res1, res2
}
