package main

import (
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
)

// Data models

type Object struct {
	ID        uint      `json:"id" gorm:"primaryKey"`
	Name      string    `json:"name"`
	Address   string    `json:"address"`
	CreatedAt time.Time `json:"created_at"`
}

type WorkOrder struct {
	ID           uint      `json:"id" gorm:"primaryKey"`
	ScheduledFor time.Time `json:"scheduled_for"`
	Status       string    `json:"status"`
}

type WorkLog struct {
	ID          uint      `json:"id" gorm:"primaryKey"`
	WorkOrderID uint      `json:"work_order_id"`
	PerformedAt time.Time `json:"performed_at"`
	PerformerID uint      `json:"performer_id"`
	Description string    `json:"description"`
}

func setupDB() *gorm.DB {
	db, err := gorm.Open(sqlite.Open("data.db"), &gorm.Config{})
	if err != nil {
		panic(err)
	}
	if err := db.AutoMigrate(&Object{}, &WorkOrder{}, &WorkLog{}); err != nil {
		panic(err)
	}
	return db
}

func main() {
	db := setupDB()
	r := gin.Default()

	r.GET("/", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"status": "ok"})
	})

	// Objects
	r.POST("/objects", func(c *gin.Context) {
		var o Object
		if err := c.ShouldBindJSON(&o); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		if err := db.Create(&o).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusCreated, o)
	})
	r.GET("/objects", func(c *gin.Context) {
		var list []Object
		if err := db.Find(&list).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusOK, list)
	})

	// Work orders (minimal)
	r.POST("/workorders", func(c *gin.Context) {
		var o WorkOrder
		if err := c.ShouldBindJSON(&o); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		if o.Status == "" {
			o.Status = "PENDING"
		}
		if err := db.Create(&o).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusCreated, o)
	})
	r.GET("/workorders", func(c *gin.Context) {
		var list []WorkOrder
		if err := db.Find(&list).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusOK, list)
	})

	// Work logs
	r.POST("/worklogs", func(c *gin.Context) {
		var wl WorkLog
		if err := c.ShouldBindJSON(&wl); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		var order WorkOrder
		if err := db.First(&order, wl.WorkOrderID).Error; err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "work order not found"})
			return
		}
		if wl.PerformedAt.IsZero() {
			wl.PerformedAt = time.Now()
		}
		if err := db.Create(&wl).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusCreated, wl)
	})
	r.GET("/worklogs", func(c *gin.Context) {
		var list []WorkLog
		if err := db.Find(&list).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusOK, list)
	})

	r.Run(":8080")
}
