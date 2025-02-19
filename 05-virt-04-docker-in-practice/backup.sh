#!/bin/sh

docker run --rm --entrypoint "" \
    -v /opt/backup:/opt/backup \
    --network shvirtd-example-python_backend \
    lauragrechenko/mysqldump-fixed \
    mysqldump --opt -h shvirtd-example-python-db-1 -u root -p"YtReWq4321" --result-file=/opt/backup/dumps.sql virtd