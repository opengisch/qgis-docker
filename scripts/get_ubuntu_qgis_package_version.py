#!/usr/bin/env python3

# This scripts will output the last LTR and stable_tag QGIS versions for Ubuntu
# Formatted as json: {"stable_tag": "3.14.0", "ltr_tag": "3.10.7"}

from apt_repo import APTRepository
import argparse
import re
import json

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('-d', '--dist', help='The Ubuntu distribution', default='bionic')
    args = parser.parse_args()
    dist = args.dist

    data = {}
    for ltr in (True, False):
        url = 'http://qgis.org/ubuntu{}'.format('-ltr' if ltr else '')
        components = ['main']
        repo = APTRepository(url, dist, components)
        package = repo.get_packages_by_name('qgis')[0]
        assert package.package == 'qgis'
        # https://regex101.com/r/lkuibv/2
        p = re.compile('^1:(\d(?:\.\d+)+)(?:\+\d+{})(?:\-\d+)?$'.format(dist))
        m = p.match(package.version)
        data['ltr' if ltr else 'stable'] = m.group(1)

    print(json.dumps(data))