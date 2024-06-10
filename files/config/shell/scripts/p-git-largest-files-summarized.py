import subprocess
import re
import os

def sizeof_fmt(num, suffix="B"):
    for unit in ("", "Ki", "Mi", "Gi", "Ti", "Pi", "Ei", "Zi"):
        if abs(num) < 1024.0:
            return f"{num:3.1f}{unit}{suffix}"
        num /= 1024.0
    return f"{num:.1f}Yi{suffix}"

if __name__ == "__main__":
    rev_list_cmd = subprocess.run(['git', 'rev-list', '--objects', '--all'], check=True, capture_output=True)
    awk_cmd = subprocess.run(['awk', '{print $1}'], input=rev_list_cmd.stdout, check=True, capture_output=True)
    git_cat_file = subprocess.run(['git', 'cat-file', '--batch-check'], input=awk_cmd.stdout, check=True, capture_output=True)

    output = git_cat_file.stdout.decode('utf-8')

    rev_list_output = rev_list_cmd.stdout.decode()
    rev_list_output_segments = re.split(' |\n', rev_list_output)

    object_sha_to_file_path = {}

    cwd = os.getcwd()
    i = 0
    while i < len(rev_list_output_segments) - 1:
        current_len = len(rev_list_output_segments[i])
        next_len = len(rev_list_output_segments[i+1])

        # trying to find segment + file_path segment pairs
        if current_len == 40 and next_len != 40:
            # empty path, not interesting
            if next_len == 0:
                i+=2
                continue

            sha=rev_list_output_segments[i]
            file_path=rev_list_output_segments[i+1]

            object_sha_to_file_path[sha] = file_path

            i+=2

        i+=1

    file_sizes = {}

    output_lines = output.splitlines()
    for line in output_lines:
        segments = line.split(" ")
        sha = segments[0]
        otype = segments[1]

        # this will still include text files, like package.lock, which should be quite alright
        if otype != "blob":
            continue

        size = int(segments[2])

        path = ''
        if sha in object_sha_to_file_path:
            path = object_sha_to_file_path[sha]
        else:
            continue

        if path in file_sizes:
            previous_size = int(file_sizes[path])
            file_sizes[path]=size+previous_size
        else:
            file_sizes[path] = size
        
    for k, v in sorted(file_sizes.items(), key=lambda x:x[1], reverse=True):
        path=k
        size_in_bytes=v

        if size_in_bytes < 1.049e+7:
            break

        human_readable_size=sizeof_fmt(int(size_in_bytes))
        print(path, human_readable_size)

