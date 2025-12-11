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

    //   a b c
    // a 1 0 0
    // b 0 0 1
    // c 1 0 0

    print_graph :: proc(graph: [][]bool, graph_indexes:map[string]uint) {
        fmt.printf("    ")
        for i in 0..<len(graph) {
            s := ""
            for k, v in graph_indexes {
                if int(v) == i {
                    s = k
                }
            }
            fmt.printf("%s    ", s)
        }
        fmt.printf("\n")
        for i in 0..<len(graph) {
            s := ""
            for k, v in graph_indexes {
                if int(v) == i {
                    s = k
                }
            }
            fmt.println(s, graph[i])
        }
    }

    graph := make([][]bool, height + 1)
    for y in 0..<height + 1 {
        graph[y] = make([]bool, height + 1) // plus 1 to make room for "out"
    }

    graph_indexes := make(map[string]uint)
    defer delete(graph_indexes)
    
    graph_indexes["out"] = 0

    index := uint(1)
    for line in lines {
        split := strings.split(line, " ")

        id_str := split[0][:len(split[0])-1]

        if !(id_str in graph_indexes) {
            graph_indexes[id_str] = index
            index += 1
        }

        for s in split[1:] {
            if !(s in graph_indexes) {
                graph_indexes[s] = index
                index += 1
            }
            graph[graph_indexes[id_str]][graph_indexes[s]] = true
        }
    }
    // square matrix
    count_paths :: proc(start:string, end:string, graph:[][]bool, graph_indexes: map[string]uint) -> int{
        visited_graph := make([]bool, len(graph))
        // TODO: need to delete those 2 (not really)

        q: queue.Queue(uint)
        queue.init(&q)
        defer queue.destroy(&q)
        
        queue.push_back(&q, graph_indexes["you"])
        count := 0
        for queue.len(q) > 0 {
            idx := queue.pop_front(&q)
            visited_graph[idx] = true

            for connected, i in graph[idx] {
                if !connected {
                    continue
                }
                if uint(i) == graph_indexes["out"] {
                    count += 1
                    continue
                }
                if !visited_graph[i] {
                    queue.push_back(&q, uint(i))
                }
            }
        }
        return count
    }
    // print_graph(graph, graph_indexes)

    res1 := count_paths("you", "out", graph, graph_indexes)
        
    res2 := 0

    return res1, res2
}
