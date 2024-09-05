#!/bin/bash

# sample : sample shell script for development

# 0. set hw informations / check if sample.sh already executed
# Prevent running sample.sh when it already executed.
PROGNAME=$(basename $0)
if [ -f "./.samplelock" ]; then
    echo "$PROGNAME: $PROGNAME already executed. Run ./sample_reset.sh to reset." >&2
    exit 1
fi

# make lockfile
> ".samplelock"

# Set hw information.
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

# Print information of HW
echo "< $HW_NAME scoring system >"
echo "> # of problem : ${HW_INFO_PROB_NUM}"
for ((prob_num=0; prob_num<$HW_INFO_PROB_NUM; prob_num++)); do
    printf "> Problem ${HW_PROB[prob_num]}: \n"

    case_len=${HW_PROB_CASE[prob_num]}

    for ((case_num=0; case_num<${case_len}; case_num++)); do
        printf "\tcase $((case_num+1))\n"
    done

done


# 1. unzip sample submission

printf "\n1. Unzip submissions\n"

while read sid; do
    tmp_sid=$(echo "$sid" | grep -oe '^[0-9]*')
    unzip_file="./student_submission/sample_${tmp_sid}.zip"

    printf ">> student id : ${tmp_sid}\n"

    if [ -f $unzip_file ]; then
        unzip "$unzip_file" -d "./student_submission/sample_${tmp_sid}" > /dev/null
        printf "${tmp_sid}\n" >> "./sample_student_list_submitted.txt"
        printf ">>> unzip success\n"
    else
        printf "${tmp_sid}\n" >> "./sample_student_list_not_submitted.txt"
        printf ">>> no zip file submitted\n"
    fi

done < $STUDENT_LIST


# 2. combine submission and case main

printf "\n2. combine submission and cases\n"

while read sid; do
    tmp_sid=$(echo "$sid" | grep -oe '^[0-9]*')
    mkdir "./outputs/sample_${tmp_sid}"

    # copy student submission to make case main
    for ((prob_num=0; prob_num<$HW_INFO_PROB_NUM; prob_num++)); do
        prob_name="${HW_PROB[prob_num]}"
        case_len="${HW_PROB_CASE[prob_num]}"
        submission_file="./student_submission/sample_${tmp_sid}/sample_${HW_NAME}_${prob_name}_${tmp_sid}.cpp"
        
        for ((case_num=1; case_num<$((case_len+1)); case_num++)); do
            output_file="./outputs/sample_${tmp_sid}/${HW_NAME}_${prob_name}_case_${case_num}_${tmp_sid}.cpp"
            grading_case="./grading_cases/sample_${HW_NAME}_${prob_name}_case_${case_num}.cpp"
            
            if [ -f $submission_file ]; then
                cat "${submission_file}" >> "${output_file}"
                printf "\n" >> "${output_file}"
                cat "${grading_case}" >> "${output_file}"
            fi
        done

    done

done < $STUDENT_LIST_SUBMITTED



# 3. compile cases and make outputs

printf "\n3. compile cases and make outputs, make diff file\n"

while read sid; do
    tmp_sid=$(echo "$sid" | grep -oe '^[0-9]*')

    printf "\n> student id: ${tmp_sid}\n"

    for ((prob_num=0; prob_num<$HW_INFO_PROB_NUM; prob_num++)); do
        prob_name=${HW_PROB[prob_num]}
        case_len=${HW_PROB_CASE[prob_num]}
        
        echo ">> HW ${prob_name} compile starts"
       
        for ((case_num=1; case_num<$((case_len+1)); case_num++)); do
            
            printf ">>> case ${case_num} > "

            grading_case="./grading_cases/sample_${HW_NAME}_${prob_name}_case_${case_num}.output"
            output_file="./outputs/sample_${tmp_sid}/${HW_NAME}_${prob_name}_case_${case_num}_${tmp_sid}"
            
            if [ -f "${output_file}.cpp" ]; then
                g++ -o "${output_file}.out" "${output_file}.cpp" > "${output_file}_compile_result.txt" 2>&1
            else
                printf "E: file does not exist\n"
                continue
            fi
            
            if [ "$(cat ${output_file}_compile_result.txt | wc -l)" -ge 1 ]; then
                printf " E: compile error\n"
            else
                "${output_file}.out" > "${output_file}_output.txt" 
                printf " compile success\n"
                diff -u --strip-trailing-cr "${grading_case}" "${output_file}_output.txt" >> "${output_file}_output_diff.txt"
            fi

        done

    done

done < $STUDENT_LIST_SUBMITTED



# 4. score with outputs

printf "\n4. score using outputs\n"

while read sid; do
    tmp_sid=$(echo "$sid" | grep -oe '^[0-9]*')

    printf "> student id: ${tmp_sid}\n"

    result_json="./outputs/sample_${tmp_sid}/sample_${tmp_sid}_result.json"
    # printf "student id: ${tmp_sid}\n" >> "$result_json"
    
    printf "{\n" >> $result_json

    for ((prob_num=0; prob_num<$HW_INFO_PROB_NUM; prob_num++)); do
        prob_name="${HW_PROB[prob_num]}"
        case_len="${HW_PROB_CASE[prob_num]}"

        output_file="./outputs/sample_${tmp_sid}/${HW_NAME}_${prob_name}_case_1_${tmp_sid}"
        if [ ! -f "${output_file}_compile_result.txt" ]; then
            printf "\"${prob_name}\" : \"file-not-submitted\",\n" >> "$result_json"
        else
            printf "\"${prob_name}\": \"file-submitted\",\n" >> "$result_json"
        

            for ((case_num=1; case_num<$((case_len+1)); case_num++)); do

                output_file="./outputs/sample_${tmp_sid}/${HW_NAME}_${prob_name}_case_${case_num}_${tmp_sid}"
                
                if [ "$(cat ${output_file}_compile_result.txt | wc -l)" -ge 1 ]; then
                    printf "\"${prob_name}-case-${case_num}\" : \"compile-error\",\n" >> "$result_json"
                elif [ "$(cat ${output_file}_output_diff.txt | wc -l)" -ge 1 ]; then
                    printf "\"${prob_name}-case-${case_num}\" : \"fail\",\n" >> "$result_json"
                else
                    printf "\"${prob_name}-case-${case_num}\" : \"pass\",\n" >> "$result_json"
                fi

            done
        fi

    done
    printf "\"dummy\" : \"dummy\"\n" >> "$result_json"
    printf "}\n" >> "$result_json"

done < $STUDENT_LIST_SUBMITTED



# 5. Print Reports using sample_print.sh

printf "\n5. Print reports using sample_print.sh\n"
while read sid; do
    tmp_sid=$(echo "$sid" | grep -oe '^[0-9]*')

    printf "> student id: ${tmp_sid}\n"
    ./sample_print.sh $tmp_sid
done < $STUDENT_LIST


# 6. Score student's submission based on result file and make one result.csv

printf "\n6. Score student submission based on result file and make one result.csv\n"
python sample_grade.py


printf "\n<<< FINISHED >>>\n"