#!/bin/bash

set -e

service_name="test"
service_container="run_tests"
test_container_name="$service_name"_"$service_container"_1
test_container_alt_name="$service_name"-"$service_container"_1

docker compose --profile test up --build

set +e

exit_code=$(docker inspect -f '{{.State.ExitCode}}' $test_container_name 2>/dev/null)
if [ -z "$exit_code" ]; then
    exit_code=$(docker inspect -f '{{.State.ExitCode}}' $test_container_alt_name 2>/dev/null)
fi

echo exit_code = $exit_code
exit $exit_code
