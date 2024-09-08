package main

import "github.com/aws/aws-lambda-go/lambda"

func main() {
	println("Hello, World!")
	lambda.Start(handler)
}

func handler() error {
	println("Hello, Lambda!")
	println("GoodBye, Lambda!")
	return nil
}
