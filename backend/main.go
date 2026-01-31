package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"time"
)

// Response represents a standard API response
type Response struct {
	Success bool        `json:"success"`
	Message string      `json:"message,omitempty"`
	Data    interface{} `json:"data,omitempty"`
	Error   string      `json:"error,omitempty"`
}

// HealthCheck response
type HealthCheck struct {
	Status    string `json:"status"`
	Timestamp string `json:"timestamp"`
	Version   string `json:"version"`
}

func main() {
	// Get port from environment variable (for deployment platforms like Render, Railway)
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080" // Fallback for local dev
	}

	// Setup routes
	http.HandleFunc("/", handleRoot)
	http.HandleFunc("/health", handleHealth)
	http.HandleFunc("/api/v1/status", handleStatus)

	// Start server
	addr := ":" + port
	log.Printf("🚀 Monocle API Server starting on http://localhost%s", addr)
	log.Printf("📍 Health check: http://localhost%s/health", addr)

	if err := http.ListenAndServe(addr, nil); err != nil {
		log.Fatalf("❌ Server failed to start: %v", err)
	}
}

// handleRoot - Welcome endpoint
func handleRoot(w http.ResponseWriter, r *http.Request) {
	if r.URL.Path != "/" {
		http.NotFound(w, r)
		return
	}

	response := Response{
		Success: true,
		Message: "Welcome to Monocle API",
		Data: map[string]string{
			"version": "1.0.0",
			"docs":    "/api/v1/docs",
		},
	}

	sendJSON(w, http.StatusOK, response)
}

// handleHealth - Health check endpoint for monitoring
func handleHealth(w http.ResponseWriter, r *http.Request) {
	health := HealthCheck{
		Status:    "healthy",
		Timestamp: time.Now().UTC().Format(time.RFC3339),
		Version:   "1.0.0",
	}

	sendJSON(w, http.StatusOK, health)
}

// handleStatus - API status endpoint
func handleStatus(w http.ResponseWriter, r *http.Request) {
	response := Response{
		Success: true,
		Message: "API is operational",
		Data: map[string]interface{}{
			"uptime":      time.Since(startTime).String(),
			"environment": getEnv("ENV", "development"),
			"go_version":  "1.21+",
		},
	}

	sendJSON(w, http.StatusOK, response)
}

// sendJSON writes a JSON response
func sendJSON(w http.ResponseWriter, status int, data interface{}) {
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Access-Control-Allow-Origin", "*") // CORS for Flutter web
	w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
	w.WriteHeader(status)

	if err := json.NewEncoder(w).Encode(data); err != nil {
		log.Printf("Error encoding JSON: %v", err)
	}
}

// getEnv gets environment variable with fallback
func getEnv(key, fallback string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return fallback
}

// Track server start time for uptime
var startTime = time.Now()

func init() {
	fmt.Println(`
╔══════════════════════════════════════╗
║         MONOCLE API SERVER           ║
║      Connect. Engage. Earn.          ║
╚══════════════════════════════════════╝
	`)
}
