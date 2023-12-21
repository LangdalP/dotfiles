#! /usr/bin/env bash

source $HOME/Projects/svv/gauth/gauth.sh

source $HOME/dotfiles/svv/tf-switch.sh

export DATEX_USERNAME=$(cat $HOME/Secrets/datex_username.txt)
export DATEX_PASSWORD=$(cat $HOME/Secrets/datex_password.txt)

# export DATEX_USERNAME=$(op read "op://Saga/Datex/username")
# export DATEX_PASSWORD=$(op read "op://Saga/Datex/password")

export TOMTOM_API_KEY=$(cat $HOME/Secrets/tomtom_api_key.txt)

export SAGA_USER_EMAIL="peder.voldnes.langdal@vegvesen.no"
export SAGA_VERIFY_LB_SECRET=false

export PATH=$PATH:~/Code/SVV/gauth
