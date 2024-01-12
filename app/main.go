package main

import (
	"encoding/json"
	"io"
	"log"
	"math/rand"
	"os"
	"time"
)

func main() {

	file, err := os.Open("one_liners.json")
	if err != nil {
		log.Fatal("Error opening file:", err)
		return
	}
	defer file.Close()

	content, err := io.ReadAll(file)
	if err != nil {
		log.Fatalf("Failed to read one liners from file: %v", err)
	}

	var oneLiners []string

	err = json.Unmarshal(content, &oneLiners)
	if err != nil {
		log.Fatal("failed to unmarshall data")
	}

	rand.Seed(time.Now().UnixNano())
	for {
		randomNumber := rand.Intn(5) + 1
		randomIndex := rand.Intn(len(oneLiners))
		log.Println(oneLiners[randomIndex])
		time.Sleep(time.Duration(randomNumber * int(time.Second)))
	}
}
