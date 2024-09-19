package main

import "github.com/aws/aws-lambda-go/lambda"

func main() {
	lambda.Start(handler)
}

type Response struct {
	Message string `json:"message"`
}

func handler() (Response, error) {
	println("Hello, ServiceB!")
	println("GoodBye, Lambda!")
	return Response{Message: "Hello, Lambda!"}, nil
}
