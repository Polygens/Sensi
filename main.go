package main

import (
	"net/http"
	"os"
	"path/filepath"

	log "github.com/sirupsen/logrus"
	"github.com/spf13/viper"

	"github.com/polygens/Sensi/sensing"
)

var version string

func main() {
	log.Infof("Starting %s version: %s", filepath.Base(os.Args[0]), version)

	viper.SetConfigName("defaults")
	viper.AddConfigPath(".")
	err := viper.ReadInConfig()
	if err != nil {
		log.Fatalf("Fatal error config file: %s \n", err)
	}

	logLvl, err := log.ParseLevel(viper.GetString("env"))
	if err != nil {
		log.Fatalf("Failed to set log level: %s \n", err)
	}

	log.SetLevel(logLvl)

	sensing.Init()

	log.Fatal(http.ListenAndServe(viper.GetString("address"), nil))
}
