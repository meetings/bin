#!/bin/bash

find /var/lib/puppet/clientbucket/ -type f -mtime +45 -atime +45 -print0 | xargs -0 rm
