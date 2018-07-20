# Splits I/O Lambda Job
This is an AWS Lambda job which is triggered automatically by S3 when a new file is uploaded. It then hits an endpoint
in Rails that tells it to parse the newly-uploaded run.

This is required for multi-run uploads, where one user uploads e.g. 20 runs at once but doesn't visit any of them.
Because clients upload directly to S3 and there's no final request to Rails after the upload finishes, Rails can't know
when the runs have finished uploading. Single-run uploads get through this fine because the browser visits the run after
the upload finishes, which lets Rails know it's okay to parse.

In the future, it is possible this job may also do the parsing itself, which would lighten the memory and CPU load on
Rails boxes. It has some rudimentary LiveSplit Core support at the moment, but it is not being used in production.

## Running
To run this job locally for testing, run
```sh
npm run docker
```

## Deploying
This job is not super well-integrated with the standard deploy process yet. Deploying it is manual action.

To deploy it, you must have AWS credentials to deploy Lambda functions. Then run:
```sh
./deploy.sh
```
