#!/bin/bash
docker build -f Dockerfile -t chorusab/fsh-fhir-build-image:"$1" -t chorusab/fsh-fhir-build-image:latest .
