#!/bin/bash

# sample print : print final score, test case, difference when sample.sh run

# if sample.sh does not run, it should not be run.
if [ ! -f "./.samplelock" ]; then
    echo "E: Run ./sample.sh first"
    exit 1
fi

# Set hw information. 
HW_NAME=hw1
HW_1=1
HW_2=2
HW_3=3

HW_1_CASE=3
HW_2_CASE=3
HW_3_CASE=3

cat <<- _EOF_

Options

1. scored result : option student_id
2. Submitted source code, compiled code, compile result : option student_id hw_num
3. case outputs, diff results : option student_id hw_num

_EOF_

read option student_id hw_num

if [ $(echo "$student_id" | grep -E '^[0-9]{9}' | wc -w) -eq 0 ]; then # student_id length is not valid
    echo "E: Invalid student_id length."
    exit
elif [ $(grep "${student_id}" ./sample_student_list.txt | wc -w) -eq 0 ]; then # student_id is not in list
    echo "E: Invalid student_id. Does not exist in student list."
    exit
elif [ $(grep "${student_id}" ./sample_student_list_submitted.txt | wc -w) -eq 0 ]; then # not submitted zip file
    echo "${student_id} does not submitted zip file."
    exit
fi

if [ $option -eq 1 ]; then
    cat "./outputs/sample_${student_id}/sample_${student_id}_result.txt"
elif [ $option -eq 2 ]; then
    if [ ! -f "./student_submission/sample_${student_id}/sample_${HW_NAME}_${hw_num}_${student_id}.cpp" ]; then
        echo "${student_id} does not submitted .cpp file"
        exit
    fi
    
    printf "\n<< Source Code >>\n"
    cat "./student_submission/sample_${student_id}/sample_${HW_NAME}_${hw_num}_${student_id}.cpp"

    printf "\n<< Compiled Code >>\n"
    case=1
    while [ $case -le 3 ]; do
        printf "\n<<< Case ${case} >>>\n"
        cat "./outputs/sample_${student_id}/${HW_NAME}_${hw_num}_case_${case}_${student_id}.cpp"
        case=$((case+1))
    done

    printf "\n<< Compile Results >>\n"
    case=1
    while [ $case -le 3 ]; do
        printf "<<< Case ${case} >>>\n"
        cat "./outputs/sample_${student_id}/${HW_NAME}_${hw_num}_case_${case}_${student_id}_compile_result.txt"
        case=$((case+1))
    done

elif [ $option -eq 3 ]; then
    if [ ! -f "./student_submission/sample_${student_id}/sample_${HW_NAME}_${hw_num}_${student_id}.cpp" ]; then
        echo "${student_id} does not submitted .cpp file"
        exit
    fi

    printf "\n<< Case Outputs >>\n"
    case=1
    while [ $case -le 3 ]; do
        printf "\n<<< Case ${case} >>>\n"
        cat "./outputs/sample_${student_id}/${HW_NAME}_${hw_num}_case_${case}_${student_id}_output.txt"
        case=$((case+1))
    done

    printf "\n<< diff Results >>\n"
    case=1
    while [ $case -le 3 ]; do
        printf "\n<<< Case ${case} >>>\n"
        cat "./outputs/sample_${student_id}/${HW_NAME}_${hw_num}_case_${case}_${student_id}_output_diff.txt"
        case=$((case+1))
    done

else
    printf "invalid option\n"
fi