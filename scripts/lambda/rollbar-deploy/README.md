# Splits I/O Rollbar Deploy Job
This is an AWS Lambda job which is triggered automatically by AWS CodePipeline when a deploy to production happens. It
then hits an endpoint in Rollbar that tells it the revision hash for the deployed commit, so that Rollbar can smartly
link directly to error-causing lines in GitHub.

## Building
```sh
npm install
```

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
