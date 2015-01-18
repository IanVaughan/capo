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

    export AWS_ACCESS_KEY_ID=xxx
    export AWS_SECRET_ACCESS_KEY=yyy

    (Can be found in ~/.fog)

    export REDISTOGO_URL=redis://localhost:6379

## Run

TODO sort running from cap deploy / puppet

    cd capo
    rackup -D


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

