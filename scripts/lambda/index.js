"use strict";
const aws = require('aws-sdk');
const fetch = require('node-fetch')
const fs = require('fs');
const lsc = require('./livesplit_core');
const pg = require('pg');
const s3 = new aws.S3();

exports.handler = function(event, context, callback) {
  const id = event['Records'][0]['s3']['object']['key'].split('/')[1]
  fetch(`https://splits.io/api/webhooks/parse?run=${id}`).then(function(response) {
    if(response.ok) {
      console.log("Complete")
    } else {
      console.error(`Bad status for parsing run ${id}: ${response.status}`)
    }
  }).catch(function(error) {
    console.error(error)
  });
};

/* // The below code was written to actually parse runs. May want this later. Leaving here because it was a pain to get
 * // LiveSplit Core and Lambda set up, and it actually works below.
exports.handler = function (event, context, callback) {
  console.log(event);
  const promises = event['Records'].map((record) => {
    return new Promise((resolve, reject) => {
      const key = record['s3']['object']['key'];
      const params = {Bucket: 'splits.io', Key: key};

      s3.getObject(params, (err, data) => {
        if (err) {
          return reject(err);
        }

        const result = lsc.Run.parseArray(data['Body'], '', false);
        console.log(`parsed: ${result.parsedSuccessfully()}`);
        if (result.parsedSuccessfully()) {
          console.log(`timer: ${result.timerKind()}`);
          const run = result.unwrap();
          console.log(`game: ${run.gameName()}`);
          resolve();
        }
      });
    });
  });

  Promise.all(promises).then(function () {
    console.log("Complete!");
  }).catch(console.error);
};
*/
