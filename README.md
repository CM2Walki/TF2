[![Code Quality](https://img.shields.io/codacy/grade/5b35c73264f446c482d8076f53845f37)](https://hub.docker.com/r/cm2network/tf2/) [![Docker Build Status](https://img.shields.io/docker/cloud/build/cm2network/tf2.svg)](https://hub.docker.com/r/cm2network/tf2/) [![Docker Stars](https://img.shields.io/docker/stars/cm2network/tf2.svg)](https://hub.docker.com/r/cm2network/tf2/) [![Docker Pulls](https://img.shields.io/docker/pulls/cm2network/tf2.svg)](https://hub.docker.com/r/cm2network/tf2/) [![](https://img.shields.io/docker/image-size/cm2network/tf2)](https://microbadger.com/images/cm2network/tf2) [![Discord](https://img.shields.io/discord/747067734029893653)](https://discord.gg/7ntmAwM)
# Supported tags and respective `Dockerfile` links
-	[`base-x32`, `latest-x32`, `base`, `latest` (*bookworm/x32/Dockerfile*)](https://github.com/CM2Walki/TF2/blob/master/bookworm/x32/Dockerfile)
-	[`metamod-x32`, `metamod` (*bookworm/x32/Dockerfile*)](https://github.com/CM2Walki/TF2/blob/master/bookworm/x32/Dockerfile)
-	[`sourcemod-x32`, `sourcemod` (*bookworm/x32/Dockerfile*)](https://github.com/CM2Walki/TF2/blob/master/bookworm/x32/Dockerfile)
-	[`base-x64`, (*bookworm/x64/Dockerfile*)](https://github.com/CM2Walki/TF2/blob/master/bookworm/x64/Dockerfile)
-	[`metamod-x64` (*bookworm/x64/Dockerfile*)](https://github.com/CM2Walki/TF2/blob/master/bookworm/x64/Dockerfile)
-	[`sourcemod-x64` (*bookworm/x64/Dockerfile*)](https://github.com/CM2Walki/TF2/blob/master/bookworm/x64/Dockerfile)

# What is Team Fortress 2?
Nine distinct classes provide a broad range of tactical abilities and personalities. Constantly updated with new game modes, maps, equipment and, most importantly, hats!
This Docker image contains the dedicated server of the game.

>  [TF2](https://store.steampowered.com/app/440/Team_Fortress_2/)

<img src="https://1000logos.net/wp-content/uploads/2020/09/Team-Fortress-2-logo.png" alt="logo" width="300"/></img>

# How to use this image
## Hosting a simple game server

Running on the *host* interface (recommended):<br/>
```console
$ docker run -d --net=host --name=tf2-dedicated -e SRCDS_TOKEN={YOURTOKEN} cm2network/tf2
```

Running using a bind mount for data persistence on container recreation:
```console
$ mkdir -p $(pwd)/tf2-data
$ chmod 777 $(pwd)/tf2-data # Makes sure the directory is writeable by the unprivileged container user
$ docker run -d --net=host -v $(pwd)/tf2-data:/home/steam/tf-dedicated/ --name=tf2-dedicated -e SRCDS_TOKEN={YOURTOKEN} cm2network/tf2
```

Running multiple instances (increment SRCDS_PORT and SRCDS_TV_PORT):
```console
$ docker run -d --net=host --name=tf2-dedicated2 -e SRCDS_PORT=27016 -e SRCDS_TV_PORT=27021 -e SRCDS_TOKEN={YOURTOKEN} cm2network/tf2
```

`SRCDS_TOKEN` **is required to be listed & reachable. Generate one here using AppID `440`:**  
[https://steamcommunity.com/dev/managegameservers](https://steamcommunity.com/dev/managegameservers)<br/><br/>
`SRCDS_WORKSHOP_AUTHKEY` **is required to use workshop features:**  
[https://steamcommunity.com/dev/apikey](https://steamcommunity.com/dev/apikey)<br/>

**It's also recommended to use "--cpuset-cpus=" to limit the game server to a specific core & thread.**<br/>
**The container will automatically update the game on startup, so if there is a game update just restart the container.**

### Using docker compose
Instead of using `docker run`, you can use `docker compose` as well, which removes the need for manually running long commands or scripts, especially useful if you want multiple servers.
An example docker-compose.yml is provided below.
```yaml
services:
  tf2:
    # Allocates a stdin (docker run -i)
    stdin_open: true
    # Allocates a tty (docker run -t)
    tty: true
    # Max CPUs to allocate, float, so e.g. 3.5 can be set.
    cpus: 4
    # Specific CPUs to allocate, 0-3 is first 4 CPUs, "0,1,2,3" can be used as well
    cpuset: 0-3
    # Use the host network, RECOMMENDED.
    network_mode: host
    # Binds /srv/tf2-dir to /home/steam/tf-dedicated in the container
    volumes:
      - /srv/tf2-dir:/home/steam/tf-dedicated
    container_name: tf2-dedicated
    environment:
      SRCDS_TOKEN: "0123456789DEADB33F"
      SRCDS_PW: "examplepassword"
      # Rest of your env vars...
    image: cm2network/tf2:latest
```
This will create a container called `tf2-dedicated`, with a bind mount for persistent data. This is especially recommended with compose, as `docker compose down` ***removes*** the defined containers.<br/>
For environment variables, you can also use an `.env` file.

# Configuration
## Environment Variables
Feel free to overwrite these environment variables, using -e (--env): 
```dockerfile
SRCDS_TOKEN="changeme" (value is is required to be listed & reachable, retrieve token here (AppID 440): https://steamcommunity.com/dev/managegameservers)
SRCDS_RCONPW="changeme" (value can be overwritten by tf/cfg/server.cfg) 
SRCDS_PW="changeme" (value can be overwritten by tf/cfg/server.cfg) 
SRCDS_PORT=27015
SRCDS_TV_PORT=27020
SRCDS_IP="0" (local ip to bind)
SRCDS_FPSMAX=300
SRCDS_TICKRATE=66
SRCDS_MAXPLAYERS=14
SRCDS_REGION=3
SRCDS_STARTMAP="ctf_2fort"
SRCDS_HOSTNAME="New TF Server" (first launch only)
SRCDS_WORKSHOP_AUTHKEY="" (required to load workshop maps)
SRCDS_CFG="server.cfg"
SRCDS_MAPCYCLE="mapcycle_default.txt" (value can be overwritten by tf/cfg/server.cfg)
SRCDS_SECURED=1 (0 to start the server as insecured)
```

## Config
The image contains static copies of the competitive config files from [UGC League](https://www.ugcleague.com/files_tf26.cfm#) and [RGL.gg](https://rgl.gg/Public/About/Configs.aspx?r=24). 

You can edit the config using this command:
```console
$ docker exec -it tf2-dedicated nano /home/steam/tf-dedicated/tf/cfg/server.cfg
```
Or if you want to explicitly specify a server config file, use the `SRCDS_CFG` environment variable.

If you want to learn more about configuring a TF2 server check this [documentation](https://wiki.teamfortress.com/wiki/Dedicated_server_configuration).

# Image Variants:
The `tf2` images come in three flavors, each designed for a specific use case, with a 64-bit version if needed.

## `tf2:latest`
This is the defacto image. If you are unsure about what your needs are, you probably want to use this one. It is a bare-minimum TF2 dedicated server containing no 3rd party plugins.<br/>

## `tf2:metamod`
This is a specialized image. It contains the plugin environment [Metamod:Source](https://www.sourcemm.net) which can be found in the addons directory. You can find additional plugins [here](https://www.sourcemm.net/plugins).

## `tf2:sourcemod`
This is another specialized image. It contains both [Metamod:Source](https://www.sourcemm.net) and the popular server plugin [SourceMod](https://www.sourcemod.net) which can be found in the addons directory. [SourceMod](https://www.sourcemod.net) supports a wide variety of additional plugins that can be found [here](https://www.sourcemod.net/plugins.php).

## `tf2:[variant]-x64`
A 64-bit version of all three variants, i.e. `latest-x64`, `metamod-x64`, and `sourcemod-x64`. This will run a fully 64-bit server, `srcds_linux64`, with a 64-bit version of Metamod or SourceMod.
### Which to use?
If you require SourceMod and aren't fully sure whether your plugins work on 64-bit servers, it's better to use the normal 32-bit variant, `tf2:sourcemod`. If you want to run a server without any plugins, `tf2:latest-x64` is preferred.

# Contributors
[![Contributors Display](https://badges.pufler.dev/contributors/CM2Walki/tf2?size=50&padding=5&bots=false)](https://github.com/CM2Walki/tf2/graphs/contributors)
