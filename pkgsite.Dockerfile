# pkgsite.Dockerfile

FROM golang:1.24.3

WORKDIR /app

# Install pkgsite using the same Go toolchain version
RUN go install golang.org/x/pkgsite/cmd/pkgsite@latest

EXPOSE 8080

CMD ["/go/bin/pkgsite", "-http=:8080"]
