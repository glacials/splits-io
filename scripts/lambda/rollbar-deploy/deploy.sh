echo "Compressing..." && \
zip --quiet -r index.zip * && \
echo "Uploding..." && \
aws --profile personal --region us-east-1 s3 cp index.zip s3://splits.io-builds/splitsio-rollbar-deploy && \
echo "Replacing AWS Lambda function..." && \
aws --profile personal --region us-east-1 lambda update-function-code --function-name splitsio-rollbar-deploy --s3-bucket splits.io-builds --s3-key splitsio-rollbar-deploy --publish && \
rm -f index.zip && \
echo "Done!"
