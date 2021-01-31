from zipfile import ZipFile
import os
from operator import or_
from functools import reduce
from fnmatch import fnmatch
import argparse


def parse_args():
    parser = argparse.ArgumentParser(description='Create zip package')
    parser.add_argument('-x', '--exclude', dest='exclude', help='files to be excluded',
                        type=lambda x: x.split(' '),
                        nargs='?', default=[])
    parser.add_argument('-o', '--output', dest='output', help='output file', type=str, nargs='?', required=True)
    parser.add_argument('-r', dest='dir', help='source directory', type=str, nargs='?', required=True)

    return parser.parse_args()


def create_zip_package(dir, name, exclude=[]):
    with ZipFile(name, 'w') as zip_file:
        for i in os.walk(dir):
            base_path, sub_dirs, files = i
            for file in files:
                file_path = os.path.join(base_path, file)
                if not reduce(or_, [fnmatch(file_path, pattern) for pattern in exclude]):
                    zip_file.write(file_path, arcname=file_path.replace(dir, ''))


if __name__ == '__main__':
    args = parse_args()
    create_zip_package(dir=args.dir, name=args.output, exclude=args.exclude)
