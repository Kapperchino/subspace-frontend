package main

import (
	"github.com/gofiber/fiber/v2"
	"os"
)

func main() {
	app := fiber.New()
	app.Static("/", "./html", fiber.Static{
		Compress: true,
	})
	app.Listen(":" + os.Getenv("PORT"))
}
