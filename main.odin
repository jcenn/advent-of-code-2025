package main
import "core:fmt"
import "core:os"

main :: proc() {
    dispatch := make(map[string]proc())
    defer delete(dispatch)

    set_up_dispatch(&dispatch);
    selected_proc := proc_from_args(&dispatch)


    if selected_proc != nil {
        selected_proc()
    }
}

proc_from_args :: proc(dispatch: ^map[string]proc()) -> proc(){
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

set_up_dispatch :: proc(dispatch : ^map[string]proc()){
    dispatch["day1"] = day_1
}