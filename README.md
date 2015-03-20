# Cap-o-matic

A sinatra server that listens for requests to deploy code.
It uses the project predefined capistrano tasks to push to the requested branch to the desired server, and logs the output so the result of each deploy can be seen by everyone.

Can be hooked upto a CI build to push code to a server on a successfully build, aka, Continuous Delivery.

## Setup

Need to copy private key onto remote machine to get source there.
(Will add to cap to push it later)

    chmod 600 ~/.ssh/id_rsa

Get the code

    git clone git@github.com:econsultancy/governor.git
    cd governor
    git co capo
    git submodule init
    git submodule update

    bundle


Ensure
nginx has a server proxy forward setup (see puppet config/branch)
AWS LB has a listener on port 8888 forwarding to port 9292 (not required now!)
AWS SG has a custom TCP rule on port 8888 from any source

## Config

    export CAPO_USERNAME=foo
    export CAPO_PASSWORD=bar

    export AWS_ACCESS_KEY_ID=xxx
    export AWS_SECRET_ACCESS_KEY=yyy

    (Can be found in ~/.fog)

    export REDISTOGO_URL=redis://localhost:6379

    eval `ssh-agent`
    ssh-add

## Run

TODO sort running from cap deploy / puppet

    cd capo
    rackup -D


$ AWS_ACCESS_KEY_ID=key AWS_SECRET_ACCESS_KEY=key REDISTOGO_URL=redis://10.36.31.193:6379 rackup -D

## Usage

Get info

    curl http://foo:bar@0.0.0.0:9898/info

You can curl the service to kick it off :

Todo a basic deploy normally :

    cap production death_star deploy

You send :

    curl http://foo:bar@0.0.0.0:9898/deploy?who=ian&app=death_star

Or, to do :

    BRANCH=newdesign-master-ian bundle exec cap custom deploy

You send :

    curl http://foo:bar@0.0.0.0:9898/deploy?branch=newdesign-master-ian&server=custom&who=ian&app=death_star


## Hubot script

Copy the capo.coffee into the hubot scripts folder

Set the server url to point to the running instance above



## TODO

ssh key something like https://github.com/bensie/sshkey
Use different redis DB number
Show progress bar, 10% 50% etc, grep output for key points
