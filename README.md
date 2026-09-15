# Project Zomboid Dedicated Server 
Project Zomboid dedicated server container with auto download of workshop mods for non-steam servers

[GitHub](https://github.com/zicstardust/project-zomboid-dedicated-server)

[Codeberg](https://codeberg.org/zicstardust/project-zomboid-dedicated-server) (Mirror Repository)

## Container
### Tags

| Tag | Description |
| :----: | :----: |
| `latest`, `stable`, `42` | Latest Stable Server |
| `42.19` | Legacy Unstable 42.19 build Server |
| `41` | Legacy Stable 41 build Server |


### Supported Architectures

| Architecture | Available 
| :----: | :----: |
| amd64 | ✅ |


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
      - 16262:16262/udp #Direct Connection
      #- 27015:27015 #Rcon port (IMPORTANT: set RCONPassword in server.ini)
    volumes:
      - /path/to/data:/data
```

## Environment variables

| variables | Function | Default | Exemple/Info
| :----: | --- | :----: | --- |
| `TZ` | Set Timezone | | |
| `PUID` | Set UID | 1000 | |
| `PGID` | Set GID | 1000 | |
| `SERVER_NAME` | Set server name | server | |
| `ADMIN_USERNAME` | Set admin username | admin | |
| `ADMIN_PASSWORD` | Set admin password | `generate random password` | Random password can be viewed in container log |
| `STEAM` | set `false` to join non-steam players | true |
| `MAX_RAM` | set max ram to JVM | 8g | 8g = 8 gigabytes<br/>2048m = 2048 megabytes |
| `LANGUAGE` | set server language | en | [Look at the supported server languages section](#supported-server-languages) |
| `UPDATE_JRE` | Update default JRE (experimental)| false | |
| `DISABLE_MOD_DOWNLOADER` | Disable auto mods downloader for non-steam server | false | [Look at the set Auto download mods for non-steam server section](#auto-download-mods-for-non-steam-server) |


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
| `es_cl` | Espanol (CL) |
| `es_mx` | Espanol (MX) |
| `fi` | Finnish |
| `fr` | Francais |
| `hu` | Hungarian |
| `id` | Indonesia |
| `it` | Italiano |
| `jp` | Japanese |
| `ko` | Korean |
| `nl` | Nederlands |
| `no` | Norsk |
| `pl` | Polish |
| `pt` | Portugese |
| `ptbr` | Brazilian Portugese |
| `ro` | Romanian |
| `ru` | Russian |
| `strew` | Strewberrie |
| `th` | Thai |
| `tr` | Turkish |
| `ua` | Ukrainian |

## Auto download mods for non-steam server
If the `STEAM` environment variable is set to `false` and you have mods in the `WorkshopItems` key in **/data/Zomboid/Server/<SERVER_NAME>.ini**.

Mods in the `WorkshopItems` key will automatically be downloaded and will replace all files in the **/data/Zomboid/mods/** directory.

To disable automatic mod downloads, set the `DISABLE_MOD_DOWNLOADER` environment variable to `true`.

For Steam server (`STEAM=true`), mod downloader will not run.


## Update from legacy container
This container has undergone significant changes; if you attempt to run the new version using the old environment variables, the container will stop execution to prevent map corruption.

Adjustments required to run the new container version:

1 - Remove the BUILD environment variable:
The BUILD environment variable is no longer used; instead, [use the container tag](#tags) corresponding to your server version.

2 - Remove the DISABLE_CACHE environment variable and the /cache volume:
The new version does not generate a download cache file, as the server is downloaded during the image build process.