#!/bin/bash

cd iac
ls 
cp google.credential.file.json /tmp

sed -i -e 's|${GOOGLE_PROJECT_KEY}|'"$GOOGLE_PROJECT_KEY"'|g' /tmp/google.credential.file.json
sed -i -e 's|${GOOGLE_PRIVATE_KEY_ID}|'"$GOOGLE_PRIVATE_KEY_ID"'|g' /tmp/google.credential.file.json
sed -i -e 's|${GOOGLE_PRIVATE_KEY}|'"$GOOGLE_PRIVATE_KEY"'|g' /tmp/google.credential.file.json
sed -i -e 's|${GOOGLE_CLIENT_EMAIL}|'"$GOOGLE_CLIENT_EMAIL"'|g' /tmp/google.credential.file.json
sed -i -e 's|${GOOGLE_CLIENT_ID}|'"$GOOGLE_CLIENT_ID"'|g' /tmp/google.credential.file.json
sed -i -e 's|${GOOGLE_AUTH_URI}|'"$GOOGLE_AUTH_URI"'|g' /tmp/google.credential.file.json
sed -i -e 's|${GOOGLE_URI_TOKEN}|'"$GOOGLE_URI_TOKEN"'|g' /tmp/google.credential.file.json
sed -i -e 's|${GOOGLE_CERT_URL}|'"$GOOGLE_CERT_URL"'|g' /tmp/google.credential.file.json

cat /tmp/google.credential.file.json