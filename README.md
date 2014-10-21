
## Setup

    export AWS_ACCESS_KEY_ID=xxx
    export AWS_SECRET_ACCESS_KEY=yyy

    ENV["REDISTOGO_URL"] || 'redis://localhost:6379'

## Run

TODO sort running from cap deploy / puppet

    cd capo
    rackup -D


You can curl the service to kick it off :

Todo a basic deploy

    cap production death_star deploy

You'd send something like

    curl http://foo:bar@0.0.0.0:9898/deploy?who=ian&app=death_star

To do something like

    BRANCH=newdesign-master-ian bundle exec cap custom deploy

You'd send this

    curl http://foo:bar@0.0.0.0:9898/deploy?branch=newdesign-master-ian&server=custom&who=ian&app=death_star


## Hubot script

Copy the capo.coffee into the hubot scripts folder

## TODO

TODO: ssh key something like https://github.com/bensie/sshkey
