#!/usr/bin/env python

import sys
import re

url_pattern = re.compile(r'href="([^"]*)"')

for line in sys.stdin:

    urls = url_pattern.findall(line)
    for url in urls:
        print(f"{url}\t1")
