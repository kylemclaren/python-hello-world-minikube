#!/bin/bash

# cleanup zombie tunnel proc
pkill -9 -f "minikube tunnel"

# cleanup minkube cluster
minikube delete --purge
