package main

import (
  "bufio"
  "fmt"
  "os"
  "strings"
)

func main() {
  reader := bufio.NewReader(os.Stdin)
  fmt.Print("Enter password: ")
  input, _ := reader.ReadString('\n')
  input = strings.TrimSpace(input)

  if input == "thisissosecure" {
    fmt.Println("Correct! The flag is: flag{youpassedre}")
  } else {
    fmt.Println("Wrong password!")
  }
}
