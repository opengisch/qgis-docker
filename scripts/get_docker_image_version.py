#!/usr/bin/env python3

# This scripts will output the QGIS versions on which LTR and stable_tag rely on
# Formatted as json: {"stable_tag": "3.14.0", "ltr_tag": "3.10.7"}

import requests
import json

url = 'https://registry.hub.docker.com/v2/repositories/opengisch/qgis/tags?page_size=10000'
data = requests.get(url).content.decode('utf-8')
tags = json.loads(data)['results']

stable_sha = None
ltr_sha = None
stable = None
ltr = None

# get available tags
availables_tags = {}
for tag in tags:
    if tag['name'].startswith('stable'):
        stable_sha = tag['images'][0]['digest']  # sha
    elif tag['name'].startswith('ltr'):
        ltr_sha = tag['images'][0]['digest']  # sha
    else:
        availables_tags[tag['name']] = tag['images'][0]['digest']

# determine what is ltr and stable
for tag, sha in availables_tags.items():
    if sha == stable_sha:
        # prefer 3.18.4 over 3.18
        if not stable or len(tag) > len(stable):
            stable = tag
    elif sha == ltr_sha:
        # prefer 3.18.4 over 3.18
        if not ltr or len(tag) > len(ltr):
            ltr = tag

output = {'stable': stable, 'ltr': ltr}
print(json.dumps(output))
