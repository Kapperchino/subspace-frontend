package main

import (
	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"os"
)

func main() {
	app := fiber.New()
	app.Use(cors.New())
	app.Static("/", "./html", fiber.Static{
		Compress: true,
	})
	app.Listen(":" + os.Getenv("PORT"))
}
