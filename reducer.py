#!/usr/bin/env python

import sys

current_url = None
current_count = 0

for line in sys.stdin:
    url, count = line.strip().split('\t')
    count = int(count)

    if current_url == url:
        current_count += count
    else:
        if current_url and current_count > 5:
            print(f"{current_url}\t{current_count}")
        current_url = url
        current_count = count

if current_url and current_count > 5:
    print(f"{current_url}\t{current_count}")
