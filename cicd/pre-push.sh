#!/usr/bin/env bash
set -e

run() {
    echo "== JayporeCI Runner Started =="

    # Clean previous run directory
    rm -rf /jaypore_ci/run/*
    cp -r /jaypore_ci/repo/. /jaypore_ci/run
    cd /jaypore_ci/run

    echo "Running pipeline: cicd.py"
    python /jaypore_ci/run/cicd/cicd.py
}

hook() {
    SHA=$(git rev-parse HEAD)
    REPO_ROOT=$(git rev-parse --show-toplevel)
    JAYPORE_CODE_DIR=$(basename "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )")

    mkdir -p /tmp/jayporeci__cidfiles

    echo "----------------------------------------------"
    echo "Jaypore CI"
    echo "Building runner image..."
    docker build \
        --build-arg JAYPORECI_VERSION=0.2.31 \
        -t im_jayporeci__pipe__$SHA \
        -f $REPO_ROOT/$JAYPORE_CODE_DIR/Dockerfile \
        $REPO_ROOT

    echo "Running container..."
    docker run -d \
        --name jayporeci__pipe__$SHA \
        -e SHA=$SHA \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v /tmp/jayporeci__src__$SHA:/jaypore_ci/run \
        -v /tmp/jayporeci__cidfiles:/jaypore_ci/cidfiles \
        --workdir /jaypore_ci/run \
        --cidfile /tmp/jayporeci__cidfiles/$SHA \
        im_jayporeci__pipe__$SHA \
        bash -c "bash /jaypore_ci/repo/$JAYPORE_CODE_DIR/pre-push.sh run"

    echo "----------------------------------------------"
}

("$@")
