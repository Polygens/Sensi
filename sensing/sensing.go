package sensing

import (
	"time"

	log "github.com/sirupsen/logrus"
	"github.com/stianeikeland/go-rpio"

	"github.com/polygens/Sensi/config"
)

// Init creates and starts the sensing
func Init(cfg *config.Config) {
	log.Debugf("Using pin: %d", cfg.SensorPin)

	err := rpio.Open()
	if err != nil {
		log.Panicf("Failed to open io input: %s", err)
	}
	defer rpio.Close()

	pin := rpio.Pin(cfg.SensorPin)

	pin.Input()       // Input mode
	res := pin.Read() // Read state from pin (High / Low)

	log.Infof("Output: %d", res)

	go backgroundTask()
}

func backgroundTask() {
	ticker := time.NewTicker(20 * time.Second)
	for ; true; <-ticker.C {
		log.Debugf("Measured")
	}
}
