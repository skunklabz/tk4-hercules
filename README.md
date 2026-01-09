# TK4-Hercules

Docker container for IBM MVS 3.8j mainframe emulator using the TK4- distribution.

## Quick Start

```bash
docker run -d \
  --name tk4-hercules \
  -p 3270:3270 \
  -p 8038:8038 \
  ghcr.io/skunklabz/tk4-hercules:latest
```

## Connect

- **3270 Terminal:** `telnet localhost 3270`
- **Web Console:** http://localhost:8038

## Using Docker Compose

```bash
docker compose up -d
```

## Build Locally

```bash
docker build -t tk4-hercules .
docker run -d -p 3270:3270 -p 8038:8038 tk4-hercules
```

## Volumes

Data is persisted in three volumes:

| Volume | Purpose |
|--------|---------|
| `conf` | Configuration files |
| `dasd` | Disk images |
| `log`  | Output logs |

## Ports

| Port | Service |
|------|---------|
| 3270 | TN3270 terminal |
| 8038 | Hercules web console |

## Platform Support

Works on Windows (Docker Desktop), Linux, and macOS.

**ARM64 Macs:** Use the `--platform linux/amd64` flag:

```bash
docker run -d --platform linux/amd64 \
  --name tk4-hercules \
  -p 3270:3270 \
  -p 8038:8038 \
  ghcr.io/skunklabz/tk4-hercules:latest
```

## License

MIT
