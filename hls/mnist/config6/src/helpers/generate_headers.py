import os
import re
src = "src"
def extract_function_signature(file_path):
    with open(file_path, "r") as f:
        content = f.read()
        match = re.search(r"\bvoid\s+(\w+)\s*\(([^)]*)\)", content)
        if match:
            func_name = match.group(1)
            func_args = match.group(2)
            return func_name, func_args
    return None, None
def generate_header_file(cpp_file):
    cpp_path = os.path.join(src, cpp_file)
    func_name, func_args = extract_function_signature(cpp_path)
    if not func_name or not func_args:
        print(f"Could not extract function signature from {cpp_file}. Skipping...")
        return
    base_name = os.path.splitext(cpp_file)[0]
    header_file = os.path.join(src, f"{base_name}.h")
    params_header = f'{base_name}_params.h'
    include_params = f'#include "{params_header}"\n' if os.path.exists(os.path.join(src, params_header)) else ''
    header_content = f"""#ifndef {base_name.upper()}_H
#define {base_name.upper()}_H
{include_params}#include "ap_int.h"
void {func_name}({func_args});
#endif // {base_name.upper()}_H
"""
    with open(header_file, "w") as f:
        f.write(header_content)
    print(f"Generated: {header_file}")
cpp_files = [f for f in os.listdir(src) if f.endswith(".cpp")]
for cpp_file in cpp_files:
    generate_header_file(cpp_file)
