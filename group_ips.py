with open("ip_whitelist.txt") as f:
    slash_8_prefixes = []
    for line in f.readlines():
        line = line.strip()
        if line:
            slash_8_prefixes.append(int(line.split(".")[0]))

    print(",".join([f"{prefix}.0.0.0/8" for prefix in sorted(set(slash_8_prefixes))]))
