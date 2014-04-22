#!/bin/bash

export RAILS_ENV=production

git pull

bundle install

rake db:migrate

touch tmp/restart.txt

