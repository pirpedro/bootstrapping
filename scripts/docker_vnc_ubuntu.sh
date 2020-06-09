#!/usr/bin/env bash

docker run -p 6080:80 -e USER=tester -e PASSWORD=tester -v /dev/shm:/dev/shm dorowu/ubuntu-desktop-lxde-vnc