#!/bin/bash

REPOSITORY=$REPO
ACCESS_TOKEN=$TOKEN
RUNNER_ALLOW_RUNASROOT=0

echo "REPO ${REPOSITORY}"
echo "ACCESS_TOKEN ${ACCESS_TOKEN}"
echo "RUNNER_ALLOW_RUNASROOT ${RUNNER_ALLOW_RUNASROOT}"

REG_TOKEN=$(curl -X POST -H "Authorization: token ${ACCESS_TOKEN}" -H "Accept: application/vnd.github+json" https://api.github.com/orgs/${REPOSITORY}/actions/runners/registration-token | jq .token --raw-output)

echo "REG_TOKEN ${REG_TOKEN}"
cd /home/docker/actions-runner

./config.sh --unattended --url https://github.com/${REPOSITORY} --token ${REG_TOKEN}

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --token ${REG_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!