package main

import (
	"html/template"
	"io"
	"net/http"
	"os"

	"github.com/labstack/echo/v4"
)

type Template struct {
	templates *template.Template
}

func (t *Template) Render(w io.Writer, name string, data interface{}, c echo.Context) error {
	return t.templates.ExecuteTemplate(w, name, data)
}

func main() {
	t := &Template{
		templates: template.Must(template.ParseGlob("templates/*.html")),
	}
	e := echo.New()
	e.Renderer = t
	e.GET("/", Hello)
	e.Logger.Fatal(e.Start(":1323"))
}

func Hello(c echo.Context) error {
	name := os.Getenv("GREETING_NAME")
	if name == "" {
		name = "World"
	}
	return c.Render(http.StatusOK, "hello", name)
}
