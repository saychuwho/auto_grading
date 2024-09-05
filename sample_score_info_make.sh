#!/bin/bash

# sample-score-info-make : make json outline for hw score info

# Get HW info
HW_LIST="./sample_hw_info.txt"

declare -a HW_INFO
while read value; do
    HW_INFO+=($value)
done < $HW_LIST

HW_NAME=${HW_INFO[0]}
HW_INFO_PROB_NUM=${HW_INFO[1]}
HW_INFO_PROB_START=2
HW_INFO_CASE_START=$((HW_INFO_PROB_START+HW_INFO_PROB_NUM))
HW_INFO_LEN=${#HW_INFO[@]}

# Set HW_PROB, HW_PROB_CASE
declare -a HW_PROB
declare -a HW_PROB_CASE

for ((prob_num=$HW_INFO_PROB_START; prob_num<$HW_INFO_CASE_START; prob_num++)); do
    HW_PROB+=( ${HW_INFO[prob_num]} )
    case_index=$((prob_num+HW_INFO_PROB_NUM))
    HW_PROB_CASE+=( ${HW_INFO[case_index]} )
done

# input prob_name case_num
print_object (){
    case_name="${1}-case-${2}"
    cat <<- _EOF_
    "${case_name}": {
        "compile-error" : ,
        "fail" : ,
        "pass" : 
    },
_EOF_
}

# input prob_name
print_problem_object (){
    local case_name="${1}"
    cat <<- _EOF_
    "${case_name}": {
        "zip-file-not-submitted" : ,
        "file-not-submitted" : , 
        "file-submitted" :
    },
_EOF_
}

# Make json file outline
JSON_FILE="./sample_hw_info_score.json"

if [[ -f $JSON_FILE ]]; then
    rm $JSON_FILE
fi

printf '{\n' >> $JSON_FILE

for ((prob_num=0;prob_num<$HW_INFO_PROB_NUM;prob_num++)); do
    prob_name="${HW_PROB[prob_num]}"
    case_len="${HW_PROB_CASE[prob_num]}"

    print_problem_object $prob_name >> $JSON_FILE

    for ((case_num=1; case_num<$((case_len+1)); case_num++)); do
        print_object $prob_name $case_num >> $JSON_FILE
    done
done

printf "\"dummy\" : \"dummy\"\n" >> $JSON_FILE
printf '}\n' >> $JSON_FILE