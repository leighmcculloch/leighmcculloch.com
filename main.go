package main

import (
	"compress/flate"
	"embed"
	"encoding/json"
	"io/fs"
	"log"
	"net/http"
	"os"

	"github.com/go-chi/chi"
	"github.com/go-chi/chi/middleware"
	"github.com/go-chi/cors"
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

	r.Group(func(r chi.Router) {
		r.Use(cors.Handler(cors.Options{
			AllowedOrigins: []string{"*"},
		}))
		r.Handle("/.well-known/stellar.toml", http.FileServer(http.FS(publicSub)))
		r.HandleFunc("/stellar/federation.json", stellarFederation)
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

func stellarFederation(w http.ResponseWriter, r *http.Request) {
	qs := r.URL.Query()
	typ := qs.Get("type")
	if typ != "name" {
		http.NotFound(w, r)
		return
	}
	q := qs.Get("q")
	if q != "leigh*leighmcculloch.com" {
		http.NotFound(w, r)
		return
	}
	err := json.NewEncoder(w).Encode(struct {
		StellarAddress string `json:"stellar_address"`
		AccountID      string `json:"account_id"`
		MemoType       string `json:"memo_type"`
		Memo           string `json:"memo"`
	}{
		StellarAddress: "leigh*leighmcculloch.com",
		AccountID:      "GCUUZV5AFZWZT5ULVJZ6UFXFQ4G6XXDR4GSDX7OSBD4TCAKFRWKLSPWK",
		MemoType:       "text",
		Memo:           "via federation",
	})
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
