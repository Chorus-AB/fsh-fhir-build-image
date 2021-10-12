#!/bin/bash
docker build -f Dockerfile -t chorusab/fsh-fhir-build-image:"$1" .
docker push chorusab/fsh-fhir-build-image:"$1"