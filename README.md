# Project Zomboid Dedicated Server 
Project Zomboid dedicated server container with auto download of workshop mods for non-steam servers

[GitHub](https://github.com/zicstardust/project-zomboid-dedicated-server)

## Container
### Tags

| Tag | Architecture | Description |
| :----: | :----: | :----: |
| [`latest`](https://github.com/zicstardust/project-zomboid-dedicated-server/blob/main/dockerfile) | amd64 | Dedicated Server |

### Registries
| Registry | Full image name | Description |
| :----: | :----: | :----: |
| [`docker.io`](https://hub.docker.com/r/zicstardust/project-zomboid-dedicated-server) | `docker.io/zicstardust/project-zomboid-dedicated-server` | Docker Hub |
| [`ghcr.io`](https://github.com/zicstardust/project-zomboid-dedicated-server/pkgs/container/project-zomboid-dedicated-server) | `ghcr.io/zicstardust/project-zomboid-dedicated-server` | GitHub |

## Usage
### Compose
``` yml
services:
  pzserver:
    container_name: project-zomboid-dedicated-server
    image: docker.io/zicstardust/project-zomboid-dedicated-server:latest
    environment:
      TZ: America/New_York
    ports:
      - 16261:16261/udp #Default_Port
      #- 16262:16262/udp #Direct Connection (only build 41 and 42)
      #- 8766:8766/udp #Steam Port 1 (only builds 40, 39 and 38)
      #- 8767:8767/udp #Steam Port 2 (only builds 40, 38 and 38)
      #- 27015:27015 #Rcon port (IMPORTANT: set RCONPassword in server.ini)
    volumes:
      - /path/to/data:/data
      - /path/to/cache:/cache #Opcional: Download cache
```

## Environment variables

| variables | Function | Default | Exemple/Info
| :----: | --- | :----: | --- |
| `TZ` | Set Timezone | | |
| `PUID` | Set UID | 1000 | |
| `PGID` | Set GID | 1000 | |
| `BUILD` | Set build server version | stable | [Look at the set build section](#set-build) |
| `ADMIN_USERNAME` | Set admin username | admin | |
| `ADMIN_PASSWORD` | Set admin password | `generate random password` | Random password can be viewed in container log |
| `STEAM` | set `false` to join non-steam players | true |
| `MAX_RAM` | set max ram to JVM | 4g | 8g = 8 gigabytes<br/>2048m = 2048 megabytes |
| `LANGUAGE` | set server language | en | [Look at the supported server languages section](#supported-server-languages) |
| `UPDATE_JRE` | Update default JRE (experimental)| false | |
| `DISABLE_MOD_DOWNLOADER` | Disable auto mods downloader for non-steam server | false | [Look at the set Auto download mods for non-steam server section](#auto-download-mods-for-non-steam-server) |
| `DISABLE_CACHE` | Disable download cache | false | |

## Set BUILD

| Value | Description | Server version |
| :----: | --- | :---: |
| `42`, `unstable` | Last Unstable Server | 42.15.3  |
| `42_oldunstable`, `outdatedunstable` | Unstable fallback for rollbacks and prior saves | 42.15.2  |
| `41`, `stable` | Last Stable Server | 41.78.18 |
| `41.78.7` | Legacy build 41 Server | 41.78.7 |
| `41.77` | Legacy build 41 Server | 41.77 |
| `40` | Classic Zomboid | 40.43 |
| `39` | Last Build 39 Server | 39.67.5 |
| `38` | Final pre-vehicles version | 38.30 |


## Supported server languages
| Value | Language name |
| :----: | --- |
| `ar` | Espanol (AR) |
| `ca` | Catalan |
| `ch` | Traditional Chinese |
| `cn` | Simplified Chinese |
| `cs` | Czech |
| `da` | Danish |
| `de` | Deutsch |
| `en` | English |
| `es` | Espanol (ES) |
| `fi` | Finnish |
| `fr` | Francais |
| `hu` | Hungarian |
| `id` | Indonesia |
| `it` | Italiano |
| `jp` | Japanese |
| `ko` | Korean |
| `nl` | Nederlands |
| `no` | Norsk |
| `ph` | Tagalog |
| `pl` | Polish |
| `pt` | Portugese |
| `ptbr` | Brazilian Portugese |
| `ro` | Romanian |
| `ru` | Russian |
| `th` | Thai |
| `tr` | Turkish |
| `ua` | Ukrainian |

## Auto download mods for non-steam server
If the `STEAM` environment variable is set to `false` and you have mods in the `WorkshopItems` key in **/data/Zomboid/Server/server.ini**.

Mods in the `WorkshopItems` key will automatically be downloaded and will replace all files in the **/data/Zomboid/mods/** directory.

To disable automatic mod downloads, set the `DISABLE_MOD_DOWNLOADER` environment variable to `true`.

For Steam server (`STEAM=true`), mod downloader will not run.
