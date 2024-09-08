FROM golang:1.22.0 as build
WORKDIR /app
# Copy dependencies list
COPY ./lambda-container-pattern/app/go.mod ./lambda-container-pattern/app/go.sum ./
# Build with optional lambda.norpc tag
COPY ./lambda-container-pattern/app/. .
RUN go build -tags lambda.norpc -o main main.go
# Copy artifacts to a clean image
FROM public.ecr.aws/lambda/provided:al2023
COPY --from=build /app/main ./main
ENTRYPOINT [ "./main" ]
