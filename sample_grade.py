import os


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



# # Get hw_info_score
# hw_info_score_file = "./sample_hw_info_score.txt"
# f = open(hw_info_file, 'r')
# hw_info_score = f.readlines()
# hw_info_score = [list(map(int, x.strip().split())) for x in hw_info_score]
# f.close()



# Get student_list
student_list_file = "./sample_student_list.txt"
f = open(student_list_file, 'r')
student_list = f.readlines()
student_list = [int(x.strip()) for x in student_list]



# write information inside csv file
result_csv_file="./sample_result.csv" # result.txt information is inside here
# result_score_csv_file="./sample_result_score.csv" # score result is stored in here
f_result = open(result_csv_file, 'w')
# f_score = open(result_score_csv_file, 'w')



# write header of information
csv_header = "student_id,"
for i in range(len(hw_prob)):
    for j in range(hw_prob_case[i]):
        csv_header += f"{i}-case-{j},"
csv_header += "\n"

f_result.write(csv_header)
# f_score.write(csv_header)

# write student's result, 
for s_id in student_list:
    student_result_file = f"./outputs/sample_{s_id}/sample_{s_id}_result.txt"
    student_result = f"{s_id},"
    # student_score_result = f"{s_id},"

    if not os.path.isfile(student_result_file):
        student_zip_not_submitted = False
        student_result += "zip-file-not-submitted," * sum(hw_prob_case)
        # student_score_result += "0," * sum(hw_prob_case)
    else:
        f_student_result = open(student_result_file, 'r')

        for i in range(len(hw_prob)):
            for j in range(hw_prob_case[i]):
                _, case_output = f_student_result.readline().strip().split()
                student_result += f"{case_output},"
    
    student_result += "\n"
    f_result.write(student_result)


f_result.close()
# f_score.close()