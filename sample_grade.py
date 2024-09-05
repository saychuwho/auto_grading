import os
import json


# Get hw_info

hw_info_file = "./sample_hw_info.txt"
f = open(hw_info_file, 'r')
hw_info = f.readlines()
hw_info = [x.strip() for x in hw_info]
f.close()

hw_name = hw_info[0]
hw_info_prob_num = int(hw_info[1])
hw_info_prob_start = 2
hw_info_case_start = hw_info_prob_start + hw_info_prob_num
hw_info_len = len(hw_info)

hw_prob = []
hw_prob_case = []

for prob_num in range(2, hw_info_case_start):
    hw_prob.append(hw_info[prob_num])
    case_index = prob_num + hw_info_prob_num
    hw_prob_case.append(int(hw_info[case_index]))


# Get student_list
student_list_file = "./sample_student_list.txt"
f = open(student_list_file, 'r')
student_list = f.readlines()
student_list = [int(x.strip()) for x in student_list]


# write information inside csv file
result_csv_file="./sample_result.csv" # result.txt information .csv
write_score_file = "./sample_result_score.csv" # score information .csv
json_score_file = "./sample_hw_info_score.json" # score information is in this .json file

f_result = open(result_csv_file, 'w')
f_score = open(write_score_file, 'w')
with open(json_score_file, 'r') as f:
    score_data=json.load(f)

# write header of information
csv_header = "student_id,"
for i in range(len(hw_prob)):
    for j in range(hw_prob_case[i]):
        csv_header += f"{hw_prob[i]}-case-{j+1},"
csv_header += "total-score,"
csv_header += "\n"

f_result.write(csv_header)
f_score.write(csv_header)


# write student's result, score
for s_id in student_list:
    student_result_file = f"./outputs/sample_{s_id}/sample_{s_id}_result.json"
    student_result = f"{s_id},"
    student_score_result = f"{s_id},"

    # student did not submitted score
    if not os.path.isfile(student_result_file):
        student_zip_not_submitted = False
        student_result += "zip-file-not-submitted," * (sum(hw_prob_case)+1)
        
        student_score_sum = 0
        for i in range(len(hw_prob)):
            for j in range(hw_prob_case[i]):
                case_score = score_data[f"{hw_prob[i]}"]["zip-file-not-submitted"]
                student_score_result += f"{case_score},"
                student_score_sum += case_score
        student_score_result += f"{student_score_sum},"

    # student did submitted score
    else:
        with open(student_result_file, 'r') as f:
            student_case_result=json.load(f)

        student_score_sum = 0
        for i in range(len(hw_prob)):
            prob_output = student_case_result[f"{hw_prob[i]}"]
            if prob_output == "file-submitted":
                student_score_sum += score_data[f"{hw_prob[i]}"][prob_output]

            for j in range(hw_prob_case[i]):
                prob_output = student_case_result[f"{hw_prob[i]}"]
                if prob_output == "file-not-submitted":
                    student_result += f"{prob_output},"
                    prob_score = score_data[f"{hw_prob[i]}"][prob_output]
                    student_score_result += f"{prob_score},"
                    student_score_sum += prob_score                   
                
                else:
                    case_output = student_case_result[f"{hw_prob[i]}-case-{j+1}"]
                    student_result += f"{case_output},"
                    
                    case_score = score_data[f"{hw_prob[i]}-case-{j+1}"][case_output]
                    student_score_result += f"{case_score},"
                    student_score_sum += case_score
        
        student_result += ","
        student_score_result += f"{student_score_sum},"


    student_result += "\n"
    student_score_result += "\n"
    f_result.write(student_result)
    f_score.write(student_score_result)

f_result.close()
f_score.close()

