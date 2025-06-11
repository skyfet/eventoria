package main

import (
	"net/http"
	"os"
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
	path := os.Getenv("DATABASE_PATH")
	if path == "" {
		path = "data.db"
	}
	db, err := gorm.Open(sqlite.Open(path), &gorm.Config{})
	if err != nil {
		panic(err)
	}
	if err := db.AutoMigrate(&Object{}, &WorkOrder{}, &WorkLog{}); err != nil {
		panic(err)
	}
	return db
}

func setupRouter(db *gorm.DB) *gin.Engine {
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
	r.GET("/objects/:id", func(c *gin.Context) {
		var o Object
		if err := db.First(&o, c.Param("id")).Error; err != nil {
			c.JSON(http.StatusNotFound, gin.H{"error": "object not found"})
			return
		}
		c.JSON(http.StatusOK, o)
	})
	r.PUT("/objects/:id", func(c *gin.Context) {
		var o Object
		if err := db.First(&o, c.Param("id")).Error; err != nil {
			c.JSON(http.StatusNotFound, gin.H{"error": "object not found"})
			return
		}
		if err := c.ShouldBindJSON(&o); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		if err := db.Save(&o).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusOK, o)
	})
	r.DELETE("/objects/:id", func(c *gin.Context) {
		if err := db.Delete(&Object{}, c.Param("id")).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		c.Status(http.StatusNoContent)
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
	r.GET("/workorders/:id", func(c *gin.Context) {
		var o WorkOrder
		if err := db.First(&o, c.Param("id")).Error; err != nil {
			c.JSON(http.StatusNotFound, gin.H{"error": "work order not found"})
			return
		}
		c.JSON(http.StatusOK, o)
	})
	r.PUT("/workorders/:id", func(c *gin.Context) {
		var o WorkOrder
		if err := db.First(&o, c.Param("id")).Error; err != nil {
			c.JSON(http.StatusNotFound, gin.H{"error": "work order not found"})
			return
		}
		if err := c.ShouldBindJSON(&o); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		if err := db.Save(&o).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusOK, o)
	})
	r.DELETE("/workorders/:id", func(c *gin.Context) {
		if err := db.Delete(&WorkOrder{}, c.Param("id")).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		c.Status(http.StatusNoContent)
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
	r.GET("/worklogs/:id", func(c *gin.Context) {
		var wl WorkLog
		if err := db.First(&wl, c.Param("id")).Error; err != nil {
			c.JSON(http.StatusNotFound, gin.H{"error": "work log not found"})
			return
		}
		c.JSON(http.StatusOK, wl)
	})
	r.PUT("/worklogs/:id", func(c *gin.Context) {
		var wl WorkLog
		if err := db.First(&wl, c.Param("id")).Error; err != nil {
			c.JSON(http.StatusNotFound, gin.H{"error": "work log not found"})
			return
		}
		if err := c.ShouldBindJSON(&wl); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		if err := db.Save(&wl).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusOK, wl)
	})
	r.DELETE("/worklogs/:id", func(c *gin.Context) {
		if err := db.Delete(&WorkLog{}, c.Param("id")).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		c.Status(http.StatusNoContent)
	})
	return r
}

func main() {
	db := setupDB()
	r := setupRouter(db)
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
	r.Run(":" + port)
}
