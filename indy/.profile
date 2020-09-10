#!/bin/sh

/usr/local/bin/setup-user.sh

if [ -f /etc/profile ]; then
 . /etc/profile
fi

