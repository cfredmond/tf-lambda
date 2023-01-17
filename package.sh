#!/bin/sh

rm -rf example-dist/

mkdir example-dist/

cp -R example/* example-dist/

cp -R venv/lib/python3.10/site-packages/* example-dist/