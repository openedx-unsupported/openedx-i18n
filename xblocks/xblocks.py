"""
Push and pull the latest sources of XBlocks to Transifex in batch.
"""
from __future__ import print_function, unicode_literals

from yaml import safe_load
from subprocess import call
from shutil import rmtree
from os import system, mkdir
from os import path
import time


def xblock_configs():
    with open('config.yaml', 'r') as config_file:
        config = safe_load(config_file)

    for xblock in config['blocks']:
        yield xblock


def pull_translations():
    for config in xblock_configs():
        repo_dir = path.join('xblocks/repos', config['name'])
        branch_name = 'i18n-bot/{time}'.format(time=time.strftime('%Y-%m-%d-%H%M%S'))
        rmtree(repo_dir, True)
        call(['git', 'clone', config['upstream_repo'], repo_dir])
        call(['git', 'remote', 'add', 'local', config['local_repo']], cwd=repo_dir)
        call(['git', 'fetch', '--all'], cwd=repo_dir)
        call(['git', 'checkout', '--branch', branch_name], cwd=repo_dir)

        for step in config['pull_steps'] + config['requirement_steps']:
            call(step.split(' '), cwd=repo_dir)
