package main

import (
	"app/pkg"

	"github.com/aws/aws-lambda-go/lambda"
)

func main() {
	lambda.Start(handler)
}

type Response struct {
	Message string `json:"message"`
}

func handler() (Response, error) {
	println(pkg.Hello() + ", ServiceA!")
	println("GoodBye, Lambda!")
	return Response{Message: "Hello, ServiceB!"}, nil
}
