#!/usr/bin/env python3

import sys
import os
import argparse
import json


def find_profile():
    firefox_path = os.path.expanduser('~/.mozilla/firefox')
    profiles = os.listdir(firefox_path)

    for profile in profiles:
        if 'default' in profile:
            return os.path.join(firefox_path, profile)

    return None


def read_json(filename):
    xulstore = None
    with open(filename) as fd:
        xulstore = json.load(fd)

    return xulstore


def write_json(filename, data):
    with open(filename, 'r+') as fd:
        fd.seek(0)
        fd.write(data)
        fd.truncate()


def main():
    parser = argparse.ArgumentParser(
        description='mgorify firefox configuration'
    )
    parser.add_argument('--profile-path', type=str, default=None,
                        help='path to default firefox profile')
    args = parser.parse_args()

    if args.profile_path is None:
        args.profile_path = find_profile()

    assert args.profile_path is not None

    xulstore = os.path.join(args.profile_path, 'xulstore.json')

    data = read_json(xulstore)

    assert data is not None

    # TODO: need to remove some stuff from @data here.

    write_json(xulstore, data)

if __name__ == '__main__':
    sys.exit(main())
