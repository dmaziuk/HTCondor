# HTCondor odds and ends

## Dockerfile

Condor in a container works on `alpine 3.10` with caveats.

1. Edit the `Dockerfile` and change condor `UID` and `GID` to suit your pool before building.

2. Run with
```
   `--net host \
    -v /etc/condor:/etc/condor \
    -v /var/lib/condor:/var/lib/condor \
    -v /var/log/condor:/var/log/condor \
    -v /var/run/docker.sock:/var/run/docker.sock 
```
  (and place you config files under `/etc/condor`, of course.)

3. Add `condor` to `docker` group on the host so it can write to `/var/run/docker.sock` and spawn 
"sibling" containers. That, and mounting `/var/run/docker.sock` is for running `docker` universe jobs:
you don't need it if you don't want them, but see below.

4. Nameservice switch does not work in `alpine` so if you have user accounts in LDAP or other 
SSO system, running as submitting user will fail. As will shared filesystem jobs, most likely.
```
UID_DOMAIN = $(FULL_HOSTNAME)
```
in the config will make all jobs run as `nobody`. 

5. There's more things that don't work in `alpine` courtesy of `glibc` so
```
START = WantDocker
```
in the config to make sure only docker universe (i.e. fully-self contained) jobs can run.

6. The `ENTRYPOINT` is simply a wrapper that redirects output of `condor_master` to a
log file. It's probably not needed, you could capture master logs through `docker`, but
as far as I can tell, other `condor` daemons will still want to log to `/var/log/condor`.
At least if you keep the default config.
