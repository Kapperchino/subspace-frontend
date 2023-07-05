FROM ubuntu:18.04 as BuilderFrontEnd

# Prerequisites
RUN apt update && apt install -y curl git unzip xz-utils zip libglu1-mesa wget

# Set up new user
WORKDIR /home/developer

# Download Flutter SDK
RUN git clone https://github.com/flutter/flutter.git
ENV PATH "$PATH:/home/developer/flutter/bin"

COPY web/* /home/developer/web/
COPY pubspec.yaml /home/developer/
COPY lib/* /home/developer/lib/
COPY ./ /home/developer

ENV BASE_URL "https://subspace-alpha.fly.dev"

# Run basic check to download Dark SDK
RUN flutter build web --dart-define=BASE_URL=$BASE_URL

FROM golang:1.20-alpine as BuilderBackend

WORKDIR /app

COPY server/go.mod  ./
COPY server/go.sum  ./

RUN go mod download

COPY server ./

RUN go build -o /app/subspace

FROM alpine

WORKDIR /app


COPY --from=BuilderBackend /app/subspace /app/subspace
COPY --from=BuilderFrontEnd /home/developer/build/web /app/html

ENV PORT 8080

EXPOSE $PORT

ENTRYPOINT ["./subspace"]
