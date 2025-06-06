import os
import re

def find_fragments(directory):
    flag_pattern = re.compile(r'FLAG_PART_(\d+)\{([a-zA-Z0-9]+)\}')
    fragments = {}

    for root, _, files in os.walk(directory):
        for filename in files:
            filepath = os.path.join(root, filename)
            try:
                with open(filepath, 'r', errors='ignore') as f:
                    content = f.read()
                    matches = flag_pattern.findall(content)
                    for match in matches:
                        part_num = int(match[0])
                        fragment = match[1]
                        fragments[part_num] = fragment
            except Exception as e:
                print(f"Could not read {filepath}: {e}")

    if fragments:
        print(f"[✓] Found {len(fragments)} flag parts")
        full_flag = ''.join(fragments[k] for k in sorted(fragments))
        print(f"🏁 Full Flag: FLAG{{{full_flag}}}")
    else:
        print("[✗] No flag fragments found.")

if __name__ == "__main__":
    import sys
    if len(sys.argv) != 2:
        print("Usage: python3 find_flag_fragments.py /path/to/search")
    else:
        find_fragments(sys.argv[1])
