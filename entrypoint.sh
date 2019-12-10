#!/bin/sh
#
# AFAICT the only reason for this is the log redirect,
# you could just run condor_master from ENTRYPOINT
#
$(condor_config_val MASTER) -f -t >> /var/log/condor/MasterLog 2>&1
