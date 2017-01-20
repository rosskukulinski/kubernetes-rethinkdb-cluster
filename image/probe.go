package main

import (
	"log"
	"os"
	r "gopkg.in/gorethink/gorethink.v2"
)


func main() {

	url := os.Getenv("RETHINKDB_URL")

	if url == "" {
		url = "localhost:28015"
	}

	session, err := r.Connect(r.ConnectOpts{
		Address: url,
		Database: "rethinkdb",
	})

	if err != nil {
		log.Fatalln(err.Error())
	}

	res, err := r.Table("server_status").Pluck("id", "name").Run(session)
	if err != nil {
		log.Fatalln(err.Error())
	}
	defer res.Close()

	if res.IsNil() {
		log.Fatalln("no server status results found")
	}

	log.Printf("A-OK!")

}

