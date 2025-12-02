package main
import "core:fmt"
import "core:strconv"
import "core:os"

main :: proc() {
    dispatch := make(map[string]proc()->int)
    defer delete(dispatch)

    set_up_dispatch(&dispatch);
    selected_proc := proc_from_args(&dispatch)

    result := selected_proc()
    fmt.println("result: ", result)
}

proc_from_args :: proc(dispatch: ^map[string]proc()->int) -> proc()->int{
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

set_up_dispatch :: proc(dispatch : ^map[string]proc()->int){
    dispatch["day_1"] = day_1
    dispatch["day_1_p2"] = day_1_p2
    dispatch["day_2"] = day_2
    dispatch["day_2_p2"] = day_2_p2
}