# PPTPD

This implements a PPTPD docker container that is able to restrict access to a
number of remote (dynamic) hosts/networks. This image and project has its roots
in [vimagick]s image, but it provides enough deviations for justifying an
existence of its own. Server setup is as in the original image. To tweak to your
own needs you will probably want to provide the following configuration files,
files that you can mount using the `-v` option of `docker run`.

* `chap-secrets` should contain user names and passwords for authorisation into
  the VPN. If you want to pinpoint specific IP addresses in the last column, you
  will have to set the `delegate` option in the PPTPD configuration file (see
  below).
  
* `pptpd.conf` should contain specific options to the PPTP daemon, this is where
  you will provide IP ranges, etc. Defaults are provided, but you might want to
  depart from these or tweak to your own needs. See [pptpd]s manual for more
  information for example.
  
* `pptpd-options` contain the options that are passed to the PPP connection.
  Good defaults are provided, you can refer to [pppd]s manual for more
  information.
  
* `firewall.conf` contains the list of hosts that are allowed to connect to the
  VPN. When this file is empty or does not exist, all connections (that can
  authorise) will be allowed. Lines starting with a dash and empty lines are
  ignored, otherwise lines should contain something that the `-s` option of
  `iptables` can ingest, including a hostname. The image support dynamic
  hostnames (see below).
  
The necessary iptables rules for accepting connection onto the default port of
`1723` and to arrange for clients to talk to one another within the VPN are
setup using the `iptables.sh` script. The script stores the host names possibly
coming from `firewall.conf` as comments in `iptables`. `loop.sh` is setup to
check that these initial host names still point to the same IP address every
minute as part of the `CMD` of the `Dockerfile`. Checking for IP address changes
is performed by `iptables-update.sh`, which takes one or several port numbers as
argument and will update the accepting rules in `iptables` as soon as the IP
address that hosts point at have been detected to have changed.

Note that the starting command will fork `loop.sh`, which is not really good
Docker practice but avoids bringing in `supervisord` or [concocter].

  [vimagick]:  https://hub.docker.com/r/vimagick/pptpd/
  [pptpd]:     http://manpages.ubuntu.com/manpages/trusty/man5/pptpd.conf.5.html
  [pppd]:      https://ppp.samba.org/pppd.html
  [concocter]: https://github.com/efrecon/concocter