Introduction
-------------

A simple way to install simple docker containers.

Docker is a deep whole that you can spend hours in. This tries to make the hole shallow.


# !!! STILL A WIP !!!


Features
--------

- Install a docker container - 1 file does all the heavy lifting per container/app.
- Passing 'uninstall' as a param uninstalls the app
- Uses docker commandline managed by systemd.
- Every container gets it's own isolated config directory and data directory
- all 'user' level systemd - little or no footprint into the 'system' level systemd setup.
- if Tailscale is installed, it will set up a systemd service to start a 'tailscale serve' for your app.


Pre-req
--------
- you need a sudo rule for the docker
- you need docker
- you may need to do docker login
- only tested on X86 at the moment - ARM compatilibity of the containers used here is not guarenteed.


List of services
----------------

- bazarr - http://localhost:6767
- deluge - http://localhost:8112
- homer - http://localhost:8080
- readarr - http://localhost:8787
- radarr - http://localhost:7878
- prowlarr - http://localhost:9696
- sabnzbd - http://localhost:8083
- sickchill - http://localhost:8081
- sickgear - http://localhost:8082
- sonarr - http://localhost:8989
- plex - http://localhost:32400
- overseer - http://localhost:5055
