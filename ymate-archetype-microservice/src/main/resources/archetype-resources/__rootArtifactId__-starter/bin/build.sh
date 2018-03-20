#!/bin/bash
cd `dirname $0`
cd ..
mvn clean compile dependency:copy-dependencies -DoutputDirectory=./target/lib  -DincludeScope=runtime