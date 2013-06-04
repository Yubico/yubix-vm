#!/bin/bash

#Update and fetch files
apt-get update -qq && apt-get -ydqq dist-upgrade
