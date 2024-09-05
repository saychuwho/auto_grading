#!/bin/bash

# sample print : print final score, test case, difference when sample.sh run

# if sample.sh does not run, it should not be run.
if [ ! -f "./.samplelock" ]; then
    echo "E: Run ./sample.sh first"
    exit 1
fi


# Set hw information.
PROGNAME=$(basename $0)

HW_LIST="./sample_hw_info.txt"
STUDENT_LIST="./sample_student_list.txt"
STUDENT_LIST_SUBMITTED="./sample_student_list_submitted.txt"

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


# declare print functions

usage (){
    echo "$PROGNAME: $PROGNAME student_id"
}

# input student_id
print_result (){
    printf "\n## Result\n"
    echo '```'
    cat "./outputs/sample_${1}/sample_${1}_result.json"
    echo '```'
}

# input student_id
print_zip_ls (){
    printf "\n## Inside .zip\n"
    echo '```'
    unzip -l "./student_submission/sample_${1}.zip"
    echo '```'
}

# input prob_num student_id
print_source_code (){
    echo "### problem-${1} submitted source code"
    if [[ -f "./student_submission/sample_${2}/sample_${HW_NAME}_${1}_${2}.cpp" ]]; then
        echo '```c++'
        cat "./student_submission/sample_${2}/sample_${HW_NAME}_${1}_${2}.cpp"
        echo " "
        echo '```'
    else
        echo "no problem-${1} submitted source code."
    fi
}

# input prob_num case_num student_id
print_compile_code (){
    echo "### problem-${1}-case-${2} compiled code"
    if [[ -f "./outputs/sample_${3}/${HW_NAME}_${1}_case_${2}_${3}.cpp" ]]; then
        echo '```c++'
        cat "./outputs/sample_${3}/${HW_NAME}_${1}_case_${2}_${3}.cpp"
        echo " "
        echo '```'  
    else
        echo "no problem-${1}-case-${2} compiled code."
    fi
}

# input prob_num case_num student_id
print_compile_result (){
    echo "### problem-${1}-case-${2} compiled result"
    if [[ -f "./outputs/sample_${3}/${HW_NAME}_${1}_case_${2}_${3}_compile_result.txt" ]]; then
        echo '```'
        cat "./outputs/sample_${3}/${HW_NAME}_${1}_case_${2}_${3}_compile_result.txt"
        echo " "
        echo '```'
    else
        echo "no problem-${1}-case-${2} compiled result"
    fi
}

# input prob_num case_num student_id
print_output_result (){
    echo "### problem-${1}-case-${2} output result"
    if [[ -f "./outputs/sample_${3}/${HW_NAME}_${1}_case_${2}_${3}_output.txt" ]]; then
        echo '```'
        cat "./outputs/sample_${3}/${HW_NAME}_${1}_case_${2}_${3}_output.txt"
        echo " "
        echo '```'
    else
        echo "no problem-${1}-case-${2} output result."
    fi
}

# input prob_num case_num student_id
print_output_diff_result (){
    echo "### problem-${1}-case-${2} output diff result"
    if [[ -f "./outputs/sample_${3}/${HW_NAME}_${1}_case_${2}_${3}_output_diff.txt" ]]; then
        echo '```'
        cat "./outputs/sample_${3}/${HW_NAME}_${1}_case_${2}_${3}_output_diff.txt"
        echo " "
        echo '```'
    else
        echo "no problem-${1}-case-${2} output diff result."
    fi
}


# code starts
# echo "$#"
if [[ $# -le 0 ]]; then
    usage
    exit 1
elif [[ $# -ge 2 ]]; then
    usage
    exit 1
fi


STUDENT_ID=${1}
if [ $(echo "$STUDENT_ID" | grep -E '^[0-9]{9}' | wc -w) -eq 0 ]; then # student_id length is not valid
    echo "${PROGNAME}: E: Invalid student_id length." >&2
    exit 1
elif [ $(grep "${STUDENT_ID}" ./sample_student_list.txt | wc -w) -eq 0 ]; then # student_id is not in list
    echo "${PROGNAME}: E: Invalid student_id. Does not exist in student list." >&2
    exit 1
fi

report_file="./reports/${STUDENT_ID}.md"
if [[ -f $report_file ]]; then
    rm $report_file
fi

printf "# $STUDENT_ID $HW_NAME scoring report\n\n" >> $report_file

# print result
if [ $(grep "${STUDENT_ID}" ./sample_student_list_submitted.txt | wc -w) -eq 0 ]; then
    printf "$STUDENT_ID did not submitted .zip file.\n" >> $report_file

else
    print_result $STUDENT_ID >> $report_file

    print_zip_ls $STUDENT_ID >> $report_file

    # print source code
    printf "\n## Submitted Source Code\n" >> $report_file
    for ((prob_num=0;prob_num<$HW_INFO_PROB_NUM;prob_num++)); do
        prob_name="${HW_PROB[prob_num]}"
        print_source_code $prob_name $STUDENT_ID >> $report_file
    done

    # print compiled code & compiled result
    printf "\n## Compiled code & compiled result\n" >> $report_file
    for ((prob_num=0;prob_num<$HW_INFO_PROB_NUM;prob_num++)); do
        prob_name="${HW_PROB[prob_num]}"
        case_len="${HW_PROB_CASE[prob_num]}"

        for ((case_num=1; case_num<$((case_len+1)); case_num++)); do
            print_compile_code $prob_name $case_num $STUDENT_ID >> $report_file
            print_compile_result $prob_name $case_num $STUDENT_ID >> $report_file
        done

    done

    # print output & diff result
    printf "\n## Output result & diff result\n" >> $report_file
    for ((prob_num=0;prob_num<$HW_INFO_PROB_NUM;prob_num++)); do
        prob_name="${HW_PROB[prob_num]}"
        case_len="${HW_PROB_CASE[prob_num]}"

        for ((case_num=1; case_num<$((case_len+1)); case_num++)); do
            print_output_result $prob_name $case_num $STUDENT_ID >> $report_file
            print_output_diff_result $prob_name $case_num $STUDENT_ID >> $report_file
        done

    done
    
fi
