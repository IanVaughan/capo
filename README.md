# Cap-o-matic

A sinatra server that listens for requests to deploy code.
It uses the project predefined capistrano tasks to push to the requested branch to the desired server,
and logs the output so the result of each deploy can be seen by everyone.

Can be hooked up to a CI build to push code to a server on a successfully build, aka, Continuous Delivery.

## Setup

## Config

## Run

    cd capo
    rackup -D

## Usage

Get info

    curl http://foo:bar@0.0.0.0:9898/info

You can curl the service to kick it off :

    curl -X PUT http://foo:bar@0.0.0.0:9898/deploy?who=ian&app=pp-name

    curl -X PUT http://foo:bar@0.0.0.0:9898/deploy?branch=my-branch&server=custom&who=ian&app=app-name


## Hubot script

Copy the capo.coffee into the hubot scripts folder

Set the server url to point to the running instance above

