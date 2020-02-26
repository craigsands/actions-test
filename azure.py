# Output IP whitelist file from GitHub runners (hosted in Microsoft Azure)

import json
from typing import Any, Dict

data: Dict[str, Any] = {}
with open("ServiceTags_Public_20200224.json") as fp:
    data = json.load(fp)
    # print(data)

for value in data.get("values", []):
    if value.get("name") == "AzureCloud.eastus":
        prefixes = value.get("properties", {}).get("addressPrefixes", [])
        with open("ip_whitelist.txt", "w") as f:
            for prefix in sorted(prefixes):
                f.write(prefix + "\n")
        # print(",".join(value.get("properties", {}).get("addressPrefixes", [])))
    # print(value.get("name"))
