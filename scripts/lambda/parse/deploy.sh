echo "Compressing..." && \
zip --quiet -r index.zip * && \
echo "Uploding..." && \
aws --profile personal --region us-east-1 s3 cp index.zip s3://splits.io-builds/splitsio-parse && \
echo "Replacing AWS Lambda function..." && \
aws --profile personal --region us-east-1 lambda update-function-code --function-name splitsio-parse --s3-bucket splits.io-builds --s3-key splitsio-parse --publish && \
rm -f index.zip && \
echo "Done!"
