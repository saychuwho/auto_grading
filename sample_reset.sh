#!/bin/bash

# sample reset : reset all process from sample.sh

# Prevent running sample_reset.sh when there are nothing to reset.
if [ ! -f "./.samplelock" ]; then
    echo "Nothing to reset."
    exit 
fi

STUDENT_LIST="./sample_student_list.txt"

while read sid; do
    tmp_sid=$(echo "$sid" | grep -oe '^[0-9]*')
    rm -rf "./student_submission/sample_${tmp_sid}"
    rm -rf "./outputs/sample_${tmp_sid}"
    rm -rf "./reports/${tmp_sid}.md"
done < $STUDENT_LIST


# remove sample_student_list_submitted.txt
rm *_submitted.txt

# remove .samplelock
rm "./.samplelock"

# remove sample_result.csv
rm "./sample_result.csv"