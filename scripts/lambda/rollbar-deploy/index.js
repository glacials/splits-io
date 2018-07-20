"use strict"
const aws = require('aws-sdk')
const fetch = require('node-fetch')
const querystring = require('querystring')

exports.handler = function(event, context, callback) {
  const codepipeline = new aws.CodePipeline()

  // Notify AWS CodePipeline of a successful job
  const putJobSuccess = function(message) {
    const params = {jobId: event["CodePipeline.job"].id}
    codepipeline.putJobSuccessResult(params, function(err, data) {
      if(err) {
        context.fail(err)
      } else {
        context.succeed(message)
      }
    })
  }
  
  // Notify AWS CodePipeline of a failed job
  const putJobFailure = function(message) {
    const params = {
      jobId: {jobId: event["CodePipeline.job"].id},
      failureDetails: {
          message: JSON.stringify(message),
          type: 'JobFailed',
          externalExecutionId: context.invokeid
      }
    }
    codepipeline.putJobFailureResult(params, function(err, data) {
        context.fail(message)
    })
  }

  const userParams = JSON.parse(event['CodePipeline.job'].data.actionConfiguration.configuration.UserParameters)
  const inputArtifact = event['CodePipeline.job'].data.inputArtifacts[0]

  const params = {
    access_token: process.env.ROLLBAR_ACCESS_TOKEN,
    environment: userParams.environment,
    revision: inputArtifact.revision,
    local_username: 'glacials',
    rollbar_username: 'glacials'
  }

  fetch(`https://api.rollbar.com/api/1/deploy`, {
    method: 'POST',
    body: querystring.stringify(params)
  }).then(function(response) {
    if(response.ok) {
      console.log("Complete")
      putJobSuccess("Success")
    } else {
      response.text().then(function(body) {
        console.error(`Bad status: ${response.status}, ${body}`)
        console.error(`Access token is ${process.env.ROLLBAR_ACCESS_TOKEN}`)
        putJobFailure("failing codepipeline job")
      })
    }
  }).catch(function(error) {
    console.error(error)
    putJobFailure(error)
  })
}
