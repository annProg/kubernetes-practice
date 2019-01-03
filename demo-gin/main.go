package main

import "github.com/gin-gonic/gin"
import "os"
import "log"
import "path/filepath"

func main() {
	r := gin.Default()
	ENV := os.Environ()
	APP_CONFIG_PATH := os.Getenv("APP_CONFIG_PATH")
	r.GET("/ping", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "pong",
		})
	})

	r.GET("/env", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": ENV,
		})
	})

	CONFIG, err := filepath.Glob(APP_CONFIG_PATH)
	if err != nil {
		log.Fatalln("List config path error", err)
	}
	r.GET("/list", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": CONFIG,
		})
	})
	r.Run() // listen and serve on 0.0.0.0:8080
}
