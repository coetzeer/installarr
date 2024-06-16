Introduction
-------------

A simple way to install simple docker containers.

Docker is a deep whole that you can spend hours in. This tries to make the hole shallow.

STILL A WIP!


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


List of services
----------------

- sonarr - http://localhost:8989
- bazarr - http://localhost:6767
- sickgear - http://localhost:8081
- sickchill - http://localhost:8081
- sickgear - http://localhost:8082
- sabnzbd - http://localhost:8083
- deluge - http://localhost:8112
