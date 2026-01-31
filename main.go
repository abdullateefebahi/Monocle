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

// TransferRequest for shard transfers
type TransferRequest struct {
	FromUserId string `json:"from_user_id"`
	ToUserId   string `json:"to_user_id"`
	Amount     int    `json:"amount"`
	Currency   string `json:"currency"` // "shards" or "orbs"
	Note       string `json:"note,omitempty"`
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

func main() {
	// Get port from environment variable (for deployment platforms like Railway)
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080" // Fallback for local dev
	}

	// Create a new ServeMux for routing
	mux := http.NewServeMux()

	// API routes (must be registered BEFORE static file handler)
	mux.HandleFunc("/health", corsMiddleware(handleHealth))
	mux.HandleFunc("/api/v1/status", corsMiddleware(handleStatus))
	mux.HandleFunc("/api/v1/shards/transfer", corsMiddleware(handleShardTransfer))
	mux.HandleFunc("/api/v1/quests/complete", corsMiddleware(handleQuestComplete))
	mux.HandleFunc("/api/v1/quests/claim", corsMiddleware(handleQuestClaim))
	mux.HandleFunc("/api/v1/users/wallet", corsMiddleware(handleGetWallet))
	mux.HandleFunc("/api/v1/users/profile", corsMiddleware(handleGetProfile))

	// Serve static files from the "public" directory (Flutter Web build)
	fs := http.FileServer(http.Dir("./public"))
	mux.Handle("/", fs)

	// Start server
	addr := ":" + port
	log.Printf("🚀 Monocle API Server starting on http://localhost%s", addr)
	log.Printf("📍 Health check: http://localhost%s/health", addr)
	log.Printf("📂 Serving Flutter Web from ./public")

	if err := http.ListenAndServe(addr, mux); err != nil {
		log.Fatalf("❌ Server failed to start: %v", err)
	}
}

// corsMiddleware adds CORS headers for Flutter web
func corsMiddleware(next http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
		w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")

		if r.Method == http.MethodOptions {
			w.WriteHeader(http.StatusOK)
			return
		}

		next(w, r)
	}
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
			"environment": getEnv("ENV", "production"),
			"go_version":  "1.21+",
			"endpoints": []string{
				"GET  /health",
				"GET  /api/v1/status",
				"POST /api/v1/shards/transfer",
				"POST /api/v1/quests/complete",
				"POST /api/v1/quests/claim",
				"GET  /api/v1/users/wallet",
				"GET  /api/v1/users/profile",
			},
		},
	}
	sendJSON(w, http.StatusOK, response)
}

// handleShardTransfer - Handle shard/orb transfers between users
func handleShardTransfer(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		sendJSON(w, http.StatusMethodNotAllowed, Response{
			Success: false,
			Error:   "Method not allowed. Use POST.",
		})
		return
	}

	var req TransferRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		sendJSON(w, http.StatusBadRequest, Response{
			Success: false,
			Error:   "Invalid request body: " + err.Error(),
		})
		return
	}

	// Validate request
	if req.FromUserId == "" || req.ToUserId == "" {
		sendJSON(w, http.StatusBadRequest, Response{
			Success: false,
			Error:   "from_user_id and to_user_id are required",
		})
		return
	}

	if req.Amount <= 0 {
		sendJSON(w, http.StatusBadRequest, Response{
			Success: false,
			Error:   "Amount must be positive",
		})
		return
	}

	// TODO: Implement actual transfer logic with Supabase
	// For now, return a success response
	sendJSON(w, http.StatusOK, Response{
		Success: true,
		Message: fmt.Sprintf("Transfer of %d %s initiated", req.Amount, req.Currency),
		Data: map[string]interface{}{
			"transaction_id": fmt.Sprintf("txn_%d", time.Now().UnixNano()),
			"from":           req.FromUserId,
			"to":             req.ToUserId,
			"amount":         req.Amount,
			"currency":       req.Currency,
			"status":         "pending",
		},
	})
}

// handleQuestComplete - Mark a quest as complete
func handleQuestComplete(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		sendJSON(w, http.StatusMethodNotAllowed, Response{
			Success: false,
			Error:   "Method not allowed. Use POST.",
		})
		return
	}

	// TODO: Implement quest completion logic
	sendJSON(w, http.StatusOK, Response{
		Success: true,
		Message: "Quest completion endpoint ready",
	})
}

// handleQuestClaim - Claim rewards for a completed quest
func handleQuestClaim(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		sendJSON(w, http.StatusMethodNotAllowed, Response{
			Success: false,
			Error:   "Method not allowed. Use POST.",
		})
		return
	}

	// TODO: Implement quest reward claim logic
	sendJSON(w, http.StatusOK, Response{
		Success: true,
		Message: "Quest claim endpoint ready",
	})
}

// handleGetWallet - Get user's wallet balance
func handleGetWallet(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		sendJSON(w, http.StatusMethodNotAllowed, Response{
			Success: false,
			Error:   "Method not allowed. Use GET.",
		})
		return
	}

	// TODO: Implement wallet fetch from Supabase
	sendJSON(w, http.StatusOK, Response{
		Success: true,
		Message: "Wallet endpoint ready",
		Data: map[string]interface{}{
			"shards": 1000,
			"orbs":   100,
		},
	})
}

// handleGetProfile - Get user's profile
func handleGetProfile(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		sendJSON(w, http.StatusMethodNotAllowed, Response{
			Success: false,
			Error:   "Method not allowed. Use GET.",
		})
		return
	}

	// TODO: Implement profile fetch from Supabase
	sendJSON(w, http.StatusOK, Response{
		Success: true,
		Message: "Profile endpoint ready",
	})
}

// sendJSON writes a JSON response
func sendJSON(w http.ResponseWriter, status int, data interface{}) {
	w.Header().Set("Content-Type", "application/json")
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
