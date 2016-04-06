#!/bin/sh
salt-call --local state.apply --file-root=. $1
