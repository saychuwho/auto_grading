#!/bin/bash

# sample : sample shell script for development

# 0. set hw informations / check if sample.sh already executed

# Prevent running sample.sh when it already executed.
if [ -f "./.samplelock" ]; then
    echo "sample.sh already executed. Run ./sample_reset.sh to reset."
    exit 
fi

> ".samplelock"

# Set hw information. 
HW_NAME=hw1
HW_1=1
HW_2=2
HW_3=3

HW_1_CASE=3
HW_2_CASE=3
HW_3_CASE=3



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

done < sample_student_list.txt



# 2. combine submission and case main

printf "\n2. combine submission and cases\n"

while read sid; do
    tmp_sid=$(echo "$sid" | grep -oe '^[0-9]*')
    mkdir "./outputs/sample_${tmp_sid}"

    # copy student submission to make case main
    # hw_1
    case=1
    while [ $case -le $HW_1_CASE ]; do
        submission_file="./student_submission/sample_${tmp_sid}/sample_${HW_NAME}_${HW_1}_${tmp_sid}.cpp"
        output_file="./outputs/sample_${tmp_sid}/${HW_NAME}_${HW_1}_case_${case}_${tmp_sid}.cpp"
        grading_case="./grading_cases/sample_${HW_NAME}_${HW_1}_case_${case}.cpp"
        
        if [ -f $submission_file ]; then
            cat "${submission_file}" >> "${output_file}"
            printf "\n" >> "${output_file}"
            cat "${grading_case}" >> "${output_file}"
        fi
        case=$((case+1))
    done

    # hw_2
    case=1
    while [ $case -le $HW_2_CASE ]; do
        submission_file="./student_submission/sample_${tmp_sid}/sample_${HW_NAME}_${HW_2}_${tmp_sid}.cpp"
        output_file="./outputs/sample_${tmp_sid}/${HW_NAME}_${HW_2}_case_${case}_${tmp_sid}.cpp"
        grading_case="./grading_cases/sample_${HW_NAME}_${HW_2}_case_${case}.cpp"
        
        if [ -f $submission_file ]; then
            cat "${submission_file}" >> "${output_file}"
            printf "\n" >> "${output_file}"
            cat "${grading_case}" >> "${output_file}"
        fi
        case=$((case+1))
    done

    # hw_3
    case=1
    while [ $case -le $HW_3_CASE ]; do
        submission_file="./student_submission/sample_${tmp_sid}/sample_${HW_NAME}_${HW_3}_${tmp_sid}.cpp"
        output_file="./outputs/sample_${tmp_sid}/${HW_NAME}_${HW_3}_case_${case}_${tmp_sid}.cpp"
        grading_case="./grading_cases/sample_${HW_NAME}_${HW_3}_case_${case}.cpp"
        
        if [ -f $submission_file ]; then
            cat "${submission_file}" >> "${output_file}"
            printf "\n" >> "${output_file}"
            cat "${grading_case}" >> "${output_file}"
        fi
        case=$((case+1))
    done

done < sample_student_list_submitted.txt



# 3. compile cases and make outputs

printf "\n3. compile cases and make outputs, make diff file\n"

while read sid; do
    tmp_sid=$(echo "$sid" | grep -oe '^[0-9]*')

    printf "\n> student id: ${tmp_sid}\n"

    # hw 1

    echo ">> HW1 compile starts"

    case=1
    while [ $case -le $HW_1_CASE ]; do

        printf ">>> case ${case} > "

        grading_case="./grading_cases/sample_${HW_NAME}_${HW_1}_case_${case}.output"
        output_file="./outputs/sample_${tmp_sid}/${HW_NAME}_${HW_1}_case_${case}_${tmp_sid}"
        if [ -f "${output_file}.cpp" ]; then
            g++ -o "${output_file}.out" "${output_file}.cpp" > "${output_file}_compile_result.txt" 2>&1
        else
            printf "E: file does not exist\n"
            case=$((case+1))
            continue
        fi
        
        if [ "$(cat ${output_file}_compile_result.txt | wc -l)" -ge 1 ]; then
            printf " E: compile error\n"
        else
            "${output_file}.out" > "${output_file}_output.txt" 
            printf " compile success\n"
            diff -u --strip-trailing-cr "${grading_case}" "${output_file}_output.txt" >> "${output_file}_output_diff.txt"
        fi

        case=$((case+1))
    done

    # hw 2

    echo ">> HW2 compile starts"

    case=1
    while [ $case -le $HW_2_CASE ]; do

        printf ">>> case ${case} > "

        grading_case="./grading_cases/sample_${HW_NAME}_${HW_2}_case_${case}.output"
        output_file="./outputs/sample_${tmp_sid}/${HW_NAME}_${HW_2}_case_${case}_${tmp_sid}"
        if [ -f "${output_file}.cpp" ]; then
            g++ -o "${output_file}.out" "${output_file}.cpp" > "${output_file}_compile_result.txt" 2>&1
        else
            printf "E: file does not exist\n"
            case=$((case+1))
            continue
        fi

        if [ "$(cat ${output_file}_compile_result.txt | wc -l)" -ge 1 ]; then
            printf " E: compile error\n"
        else
            "${output_file}.out" > "${output_file}_output.txt" 
            printf " compile success\n"
            diff -u --strip-trailing-cr "${grading_case}" "${output_file}_output.txt" >> "${output_file}_output_diff.txt"
        fi

        case=$((case+1))
    done

    # hw 3

    echo ">> HW3 compile starts"

    case=1
    while [ $case -le $HW_3_CASE ]; do

        printf ">>> case ${case} > "

        grading_case="./grading_cases/sample_${HW_NAME}_${HW_3}_case_${case}.output"
        output_file="./outputs/sample_${tmp_sid}/${HW_NAME}_${HW_3}_case_${case}_${tmp_sid}"
        if [ -f "${output_file}.cpp" ]; then
            g++ -o "${output_file}.out" "${output_file}.cpp" > "${output_file}_compile_result.txt" 2>&1
        else
            printf "E: file does not exist\n"
            case=$((case+1))
            continue
        fi

        if [ "$(cat ${output_file}_compile_result.txt | wc -l)" -ge 1 ]; then
            printf " E: compile error\n"
        else
            "${output_file}.out" > "${output_file}_output.txt"
            printf " compile success\n"
            diff -u --strip-trailing-cr "${grading_case}" "${output_file}_output.txt" >> "${output_file}_output_diff.txt"
        fi

        case=$((case+1))
    done

done < sample_student_list_submitted.txt



# 4. score with outputs

printf "\n4. score using outputs\n"

while read sid; do
    tmp_sid=$(echo "$sid" | grep -oe '^[0-9]*')

    printf "> student id: ${tmp_sid}\n"

    result_txt="./outputs/sample_${tmp_sid}/sample_${tmp_sid}_result.txt"
    printf "student id: ${tmp_sid}\n" >> "$result_txt"
    
    # hw 1
    case=1
    while [ $case -le $HW_1_CASE ]; do
        output_file="./outputs/sample_${tmp_sid}/${HW_NAME}_${HW_1}_case_${case}_${tmp_sid}"
        if [ ! -f "${output_file}_compile_result.txt" ]; then
            printf "${HW_1}-case-${case}: file not submitted\n" >> "$result_txt"
        elif [ "$(cat ${output_file}_compile_result.txt | wc -l)" -ge 1 ]; then
            printf "${HW_1}-case-${case}: compile error\n" >> "$result_txt"
        elif [ "$(cat ${output_file}_output_diff.txt | wc -l)" -ge 1 ]; then
            printf "${HW_1}-case-${case}: output does not match with case\n" >> "$result_txt"
        else
            printf "${HW_1}-case-${case}: pass\n" >> "$result_txt"
        fi

        case=$((case+1))
    done

    # hw 2
    case=1
    while [ $case -le $HW_2_CASE ]; do
        output_file="./outputs/sample_${tmp_sid}/${HW_NAME}_${HW_2}_case_${case}_${tmp_sid}"
        if [ ! -f "${output_file}_compile_result.txt" ]; then
            printf "${HW_2}-case-${case}: file not submitted\n" >> "$result_txt"
        elif [ "$(cat ${output_file}_compile_result.txt | wc -l)" -ge 1 ]; then
            printf "${HW_2}-case-${case}: compile error\n" >> "$result_txt"
        elif [ "$(cat ${output_file}_output_diff.txt | wc -l)" -ge 1 ]; then
            printf "${HW_2}-case-${case}: output does not match with case\n" >> "$result_txt"
        else
            printf "${HW_2}-case-${case}: pass\n" >> "$result_txt"
        fi

        case=$((case+1))
    done

    # hw 3
    case=1
    while [ $case -le $HW_3_CASE ]; do
        output_file="./outputs/sample_${tmp_sid}/${HW_NAME}_${HW_3}_case_${case}_${tmp_sid}"
        if [ ! -f "${output_file}_compile_result.txt" ]; then
            printf "${HW_3}-case-${case}: file not submitted\n" >> "$result_txt"
        elif [ "$(cat ${output_file}_compile_result.txt | wc -l)" -ge 1 ]; then
            printf "${HW_3}-case-${case}: compile error\n" >> "$result_txt"
        elif [ "$(cat ${output_file}_output_diff.txt | wc -l)" -ge 1 ]; then
            printf "${HW_3}-case-${case}: output does not match with case\n" >> "$result_txt"
        else
            printf "${HW_3}-case-${case}: pass\n" >> "$result_txt"
        fi

        case=$((case+1))
    done

done < sample_student_list_submitted.txt