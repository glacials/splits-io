"use strict"
const lsc = require('./livesplit_core')
const fs = require('fs')

const { Client } = require('pg')
const db = new Client()
db.connect()

const aws = require('aws-sdk')
const s3 = new aws.S3()

exports.handler = function (event, context, callback) {
  console.log(event)
  const promises = event['Records'].map((record) => {
    return new Promise((resolve, reject) => {
      const key = record['s3']['object']['key']
      const params = {Bucket: 'splits.io', Key: key}

      s3.getObject(params, (err, data) => {
        if (err) {
          return reject(err)
        }

        db.query('SELECT id FROM runs WHERE s3_filename = $1::text', [key], (err, res) => {
          console.log(err ? err.stack : res.rows[0].id)
        })

        const result = lsc.Run.parseArray(data['Body'], '', false)
        console.log(`parsed: ${result.parsedSuccessfully()}`)
        if (result.parsedSuccessfully()) {
          console.log(`timer: ${result.timerKind()}`)
          const run = result.unwrap()
          console.log(`game: ${run.gameName()}`)
          resolve()
        }
      })
    })
  })

  Promise.all(promises).then(function () {
    console.log("Complete!")
  }).catch(console.error)
}
