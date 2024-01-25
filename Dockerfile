# Use an official Go runtime as a parent image
FROM golang:1.16-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the local package files to the container's workspace
COPY ./backend .

# Build your Go app
RUN go build -o main .

# Expose port (adjust if different) for the application
EXPOSE 8080

# Run the binary program produced by `go install`
CMD ["./main"]
