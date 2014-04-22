#!/bin/bash

export RAILS_ENV=production

git pull

bundle install

rake db:migrate

rake assets:precompile

touch tmp/restart.txt

