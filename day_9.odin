package main

import "core:fmt"
import "core:math"
import "core:strconv"
import "core:strings"

day_9 :: proc(input_path:string) -> (int, int) {
    Rect :: struct {
        x, y: int,
        max_area: int,
    }

    data := read_input_file(input_path)
    defer delete(data)
    data_string := string(data)
    
    lines := strings.split_lines(data_string)
    height := len(lines) - 1
    lines = lines[:height] // remove empty string after last line

    points := make([]Rect, height)
    defer delete(points)
    
    for line, i in lines {
        point_str := strings.split(line, ",")
        point := Rect{}
        point.x, _ = strconv.parse_int(point_str[0])
        point.y, _ = strconv.parse_int(point_str[1])
        point.max_area  = 0
        
        points[i] = point
    }
    total_max_area := 0
    // check down turned diagonal
    for &point1, i in points {
        for j in i..<len(points){
            point2 := points[j]
            area := (math.abs(point2.x - point1.x)+1) * (math.abs(point2.y - point1.y)+1)
            if area > total_max_area {
                total_max_area = area
            }
        }
    }

    
    res1 := total_max_area
    res2 := 0

    return res1, res2
}
