#!/bin/bash
set -ex

sudo apt install -y nodejs npm && \
  sudo npm install n -g && \
  sudo n stable && \
  sudo apt purge -y nodejs npm && \
  sudo apt purge -y nodejs npm 
