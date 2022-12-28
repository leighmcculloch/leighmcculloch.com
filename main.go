package main

import (
	"compress/flate"
	"embed"
	"io/fs"
	"log"
	"net/http"
	"os"

	"github.com/go-chi/chi"
	"github.com/go-chi/chi/middleware"
)

//go:embed source/public source/public/.well-known
var public embed.FS

var publicSub = func() fs.FS {
	fs, err := fs.Sub(public, "source/public")
	if err != nil {
		panic(err)
	}
	return fs
}()

func main() {
	logger := log.New(os.Stdout, "", log.LstdFlags)

	r := chi.NewRouter()
	r.Use(middleware.Recoverer)
	r.Use(middleware.RequestID)
	r.Use(middleware.RealIP)
	r.Use(middleware.RequestLogger(&middleware.DefaultLogFormatter{Logger: logger}))
	r.Use(middleware.Compress(flate.BestSpeed))
	r.Use(redirectHTTPToHTTPS)

	r.Get("/health", func(w http.ResponseWriter, r *http.Request) {
		_, _ = w.Write([]byte("ok"))
	})

	r.Handle("/*", http.FileServer(http.FS(publicSub)))

	port := os.Getenv("PORT")
	if port == "" {
		port = "3000"
	}
	logger.Printf("Listening on :%s", port)
	err := http.ListenAndServe(":"+port, r)
	if err != nil {
		panic(err)
	}
}

func redirectHTTPToHTTPS(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.Header.Get("X-Forwarded-Proto") == "http" {
			loc := *r.URL
			loc.Host = r.Host
			loc.Scheme = "https"
			http.Redirect(w, r, loc.String(), http.StatusPermanentRedirect)
			return

		}
		next.ServeHTTP(w, r)
	})
}
