#!/bin/bash
CURRENT=`pwd`
DIR_NAME=`basename "$CURRENT"`
if [ $DIR_NAME == 'tool' ]
then
  cd ..
fi

echo "======="
echo "dart test --coverage"
echo "======="
fvm dart test --coverage=./coverage || exit -1
echo ""

echo "Converting to LCOV format"

fvm dart pub global activate coverage
fvm dart pub global run coverage:format_coverage --packages=.dart_tool/package_config.json --report-on=lib --lcov -o ./coverage/lcov.info -i ./coverage

echo "GENERATE COVERAGE HTML"

genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
