FROM golang:1.22.0 as build
WORKDIR /app
# Copy dependencies list
COPY ./lambda-container-pattern/go.mod ./lambda-container-pattern/go.sum .
# Build with optional lambda.norpc tag
RUN go mod download

COPY ./lambda-container-pattern/pkg .
COPY ./lambda-container-pattern/handlers/app/ handlers/service-b

RUN go build -o main handlers/service-b/main.go
# Copy artifacts to a clean image
FROM public.ecr.aws/lambda/provided:al2023
COPY --from=build /app/main /main
ENTRYPOINT [ "/main" ]
