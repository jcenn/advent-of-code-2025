package main

import "core:math"
import "core:fmt"
import "core:strconv"
import "core:strings"

has_duplicates :: proc(n:int, dup_count:int) -> bool {
   digits:int = int(math.floor(math.log10(f32(n)))) + 1
         
   // length of a single part instance that might be duplicated
   word_length := digits / dup_count
   // couldn't find a better way to easily convert int to string
   n_str := fmt.aprintf("%d", n)
   res := true 
   for i := 0; i < dup_count-1; i+=1{
      start1 := word_length*i
      start2 := start1 + word_length
      if n_str[start1 : start1 + word_length] != n_str[start2 : start2 + word_length]{
         res = false
      }
   }

   return res
}

day_2 :: proc(input_path:string) -> (int, int) {
    data := read_input_file(input_path)
    defer delete(data)
    data_string := string(data)

    sum1 := 0
    sum2 := 0
    for num_range in strings.split_iterator(&data_string, ","){
      range_separated := strings.split(num_range, "-")
        lower, _ := strconv.parse_int(range_separated[0])
        upper, _ := strconv.parse_int(range_separated[1])
         
         main_label:
         for n in lower..=upper{
           digits:int = int(math.floor(math.log10(f32(n)))) + 1
           for k in 2..=digits{
              if digits % k != 0 {
                 continue
              }
              if has_duplicates(n, k){
                  if k == 2 {
                     sum1+=n
                  }
                  sum2+=n
                  continue main_label
              }
           }
        }
    }
    return sum1, sum2
}
