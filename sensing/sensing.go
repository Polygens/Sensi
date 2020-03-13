package sensing

import (
	"net/http"
	"time"

	"github.com/prometheus/client_golang/prometheus/promhttp"
	log "github.com/sirupsen/logrus"
	"github.com/spf13/viper"
	"github.com/stianeikeland/go-rpio"
)

var inputPinID int

// Init creates and starts the sensing
func Init() {
	inputPinID = viper.GetInt("sensorPin")

	log.Debugf("Using pin: %d", viper.GetInt("sensorPin"))

	err := rpio.Open()
	if err != nil {
		log.Panicf("Failed to open io input: %s", err)
	}
	defer rpio.Close()

	pin := rpio.Pin(inputPinID)

	pin.Input()       // Input mode
	res := pin.Read() // Read state from pin (High / Low)

	log.Infof("Output: %d", res)

	go backgroundTask()

	http.Handle("/metrics", promhttp.Handler())
}

func backgroundTask() {
	ticker := time.NewTicker(20 * time.Second)
	for ; true; <-ticker.C {
		log.Debugf("Measured")
	}
}
