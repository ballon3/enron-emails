package main

import (
	"log"
	"net/http"
	"time"
	"tr-challenge/backend/pkg/api"

	"github.com/go-chi/chi"
	"github.com/go-chi/chi/middleware"
)

func Logger(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		start := time.Now()

		// Wrap response writer for capturing the status code
		ww := middleware.NewWrapResponseWriter(w, r.ProtoMajor)

		// Process request
		next.ServeHTTP(ww, r)

		// Log details after request processing
		log.Printf("Method: %s, Path: %s, Status: %d, Duration: %s\n",
			r.Method, r.URL.Path, ww.Status(), time.Since(start))
	})
}

func main() {
	r := chi.NewRouter()

	// Set up middlewares
	r.Use(middleware.Logger)

	// Set up routes
	r.Get("/search", api.SearchHandler)

	http.ListenAndServe(":8080", r)
}
