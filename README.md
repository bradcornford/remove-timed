# Docker linuxserver/transmission mod

This mod adds a script that **remove timed** torrents. 



## Usage

Moreover use [linuxserver/transmission](https://hub.docker.com/r/linuxserver/transmission) parameters, there are some others to add **remove timed** torrents functionality.

```bash
-e DOCKER_MODS=bradcornford/remove-timed:latest \
-e AUTOREMOVE=yes \
-e CRONDATE=monthly \
-e SEEDTIME=30 \
-e AUTHENABLE=yes \#optional
```



### Parameters

| Parameter           | Function                                                                                                                      |
|---------------------|-------------------------------------------------------------------------------------------------------------------------------|
| `-e AUTOREMOVE=yes` | Active a script to autoremove torrents when these have finished and met their seed time.                                      |
| `-e SEEDTIME=1`     | Seed time in days a torrent should be ignored for. **1** day is defined by default.                                           |
| `-e CRONDATE=daily` | Specify when torrents have to be removed. Options are: **monthly**, **weekly** or **daily**. **Daily** is defined by default. |
| `-e AUTHENABLE=yes` | When **user** and **pass** have been defined and **autoremove** is enabled, this parameter has to be activated.               |

\*_Setting `-e USER=username` and `-e PASS=password` is required if **AUTHENABLE=yes**. This parameteres are explained in the oficial [linuxserver/transmission](https://hub.docker.com/r/linuxserver/transmission) image._

For more information about DOCKER MODS:

* [Customizing Linuxserver Containers](https://blog.linuxserver.io/2019/09/14/customizing-our-containers/)
* [Docker-mods](https://github.com/linuxserver/docker-mods)

