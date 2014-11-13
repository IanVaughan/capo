# Description
#   <description of the scripts functionality>
#
# Dependencies:
#   "<module name>": "<module version>"
#
# Configuration:
#   CAPO_HOST  eg "http://foo:bar@0.0.0.0:9292/"
#
# Commands:
#   deploy - deploys death_star, e.g. 'deploy production'
#   deploy branch - deploys a custom branch, eg 'deploy branch newdesign-master'
#
# Notes:
#   Place in hubot scripts folder
#
# Author:
#   ianrvaughan

QS = require 'querystring'

server_url = process.env.CAPO_HOST

module.exports = (robot) ->
  robot.respond /deploy help/i, (msg) ->
    text = "Capo-o-matic at your service! (goto " + server_url + " for the web interface)\n"
    text += "deploy info - shows the last 5 deployments\n"
    text += "deploy branch <branch name> [<force>] - starts a custom deploy (of death_star) from branch name\n"
    text += "deploy <production|staging> [<force>] - starts a deploy \n"
    msg.reply(text)

  robot.respond /deploy info/i, (msg) ->
    msg.http(server_url + "/info")
      .get() (err, res, body) ->
        msg.send(body)

  robot.respond /deploy branch ([\w\-\_]+) ?(force)?/i, (msg) ->
    branch = msg.match[1]
    force = msg.match[2]

    force_set = false
    if force is 'force'
      force_set = true

    data = QS.stringify({
      branch: branch,
      server: 'custom',
      app: 'death_star',
      who: msg.message.user.name,
      force: force_set
    })

    msg.http(server_url + "/deploy?" + data)
      .get() (err, res, body) ->
        switch res.statusCode
          when 200
            msg.send(body)
          else
            msg.send("Something was wrong, try again!")
            msg.send(body)

  robot.respond /deploy (production|staging) ?(force)?/i, (msg) ->
    env = msg.match[1]
    force = msg.match[2]

    force_set = false
    if force is 'force'
      force_set = true

    data = QS.stringify({
      server: env,
      app: 'death_star',
      who: msg.message.user.name,
      force: force_set
    })

    msg.http(server_url + "/deploy")
      .post(data) (err, res, body) ->
        msg.send(res.statusCode)
        switch res.statusCode
          when 200
            msg.send(body)
          else
            msg.send("Something was wrong, try again!")
            msg.send(body)

