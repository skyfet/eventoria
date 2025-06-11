package main

import (
	"net/http"
	"net/http/httptest"
	"os"
	"testing"
)

func TestRoot(t *testing.T) {
	os.Setenv("DATABASE_PATH", ":memory:")
	db := setupDB()
	r := setupRouter(db)
	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", "/", nil)
	r.ServeHTTP(w, req)
	if w.Code != http.StatusOK {
		t.Fatalf("expected status 200, got %d", w.Code)
	}
}
