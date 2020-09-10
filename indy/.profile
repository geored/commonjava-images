#!/bin/sh

if [ -f /etc/profile ]; then
 . /etc/profile
fi
/usr/local/bin/setup-user.sh
