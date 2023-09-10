import os
import shutil
import re

def find_dependencies(file_path):
    with open(file_path, 'r') as f:
        content = f.read()
        dependencies = []

        # Match 'require' statements
        pattern = r'local\s+(\w+)\s*=\s*require\s*\(\s*[\'\"](cylibs/.+?)[\'\"]\s*\)'
        matches = re.findall(pattern, content)

        for match in matches:
            dependencies.append(match[1])

    return dependencies

def copy_dependency_to_temp(dependency):
    source_path = dependency + '.lua'
    dest_path = os.path.join('temp', dependency)

    # Create destination directory if it doesn't exist
    os.makedirs(os.path.dirname(dest_path), exist_ok=True)

    # Copy the file
    shutil.copy2(source_path, dest_path)

    print(f"'{file_path}' depends on '{dependency}'")

# Set the root directory
root_dir = 'cylibs/ui'

# Traverse the files under cylibs/ui
for root, dirs, files in os.walk(root_dir):
    for file in files:
        if file.endswith('.lua'):
            file_path = os.path.join(root, file)
            dependencies = find_dependencies(file_path)
            for dependency in dependencies:
                copy_dependency_to_temp(dependency)
