package main
import "core:fmt"
import "core:os"

// type alias to not repeat proc()->(int, int) all over the place
advent_func :: proc(input_path:string)->(int, int)

main :: proc() {
    dispatch := make(map[string]advent_func)
    defer delete(dispatch)

    set_up_dispatch(&dispatch);
    selected_proc := proc_from_args(&dispatch)
   
    if selected_proc == nil {
      return
    }
    p1_result, p2_result := selected_proc(os.args[1])
    fmt.println("part 1:", p1_result)
    fmt.println("part 2:", p2_result)
}

proc_from_args :: proc(dispatch: ^map[string]advent_func) -> advent_func{
    if len(os.args) < 2{
        fmt.println("Provide program arguments!")
        return nil
    }
    key := os.args[1]
    selected_proc := dispatch[key]
    if selected_proc == nil{
        fmt.println("Associated procedure for -> ", key, " <- not found")
        return nil
    }
    return selected_proc
}

set_up_dispatch :: proc(dispatch : ^map[string]advent_func){
    dispatch["day_1"] = day_1
    dispatch["day_2"] = day_2
    dispatch["day_3"] = day_3
    dispatch["day_4"] = day_4
    dispatch["day_5"] = day_5
    dispatch["day_6"] = day_6
    dispatch["day_7"] = day_7
}

read_input_file :: proc(path:string) -> []u8 {
    full_path := fmt.aprintf("./inputs/%s.txt", path)
    data, ok := os.read_entire_file(full_path)
    if !ok{
        err_msg := fmt.aprintf("couldn't open provided file: %s", full_path)
        panic_contextless(err_msg)
    }
    return data
}
