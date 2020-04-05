package sensing

import (
	"time"

	"github.com/gorilla/mux"
	log "github.com/sirupsen/logrus"
	"periph.io/x/periph/conn/gpio"

	"github.com/polygens/sensi/config"
)

type App struct {
	router *mux.Router
	cfg    *config.Config
	dht    DHT
}

type DHT struct {
	pin         gpio.PinIO
	numErrors   int
	lastRead    time.Time
	temperature float32
	humidity    float32
}

var app *App

// Init creates and starts the sensing
func Init(router *mux.Router, cfg *config.Config) {
	dht := DHT{}
	app = &App{router, cfg, dht}

	log.Debugf("Using pin: %d", cfg.SensorPin)

	// _, err := host.Init()
	// if err != nil {
	// 	log.Fatalf("Failed to init host: %s", err)
	// }

	// dht.pin = gpioreg.ByName(strconv.Itoa(cfg.SensorPin))
	// if dht.pin == nil {
	// 	log.Fatalf("Failed to find: %s", cfg.SensorPin)
	// }

	// go backgroundTask()
	app.setupRoutes()
}

func backgroundTask() {
	ticker := time.NewTicker(20 * time.Second)
	for ; true; <-ticker.C {
		log.Debugf("Measured")
	}
}
