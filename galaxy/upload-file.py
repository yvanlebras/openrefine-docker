import sys
from galaxy_ie_helpers import put

print(f"Uploading {sys.argv[1]} to galaxy")
put(sys.argv[1], file_type="tabular")
