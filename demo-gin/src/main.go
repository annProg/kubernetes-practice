package main

import "github.com/gin-gonic/gin"
import "os"
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

	if APP_CONFIG_PATH == "" {
		APP_CONFIG_PATH = "*"
	}

	var configs []string
	filepath.Walk(APP_CONFIG_PATH, func(path string, info os.FileInfo, err error) error {
		configs = append(configs, path)
		return nil
	})
	r.GET("/list", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": configs,
		})
	})
	r.Run() // listen and serve on 0.0.0.0:8080
}
