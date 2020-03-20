package sensing

import (
	"net/http"

	"github.com/gorilla/mux"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

func SetupRoutes(r *mux.Router) {
	r.Handle("/metrics", promhttp.Handler()).Methods("GET")
	r.HandleFunc("/ping", health).Methods("GET")
	r.HandleFunc("/ready", health).Methods("GET")
	r.HandleFunc("/live", health).Methods("GET")
}

func health(w http.ResponseWriter, request *http.Request) {
	w.WriteHeader(200)
	w.Write([]byte("pong"))
}
