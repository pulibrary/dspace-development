import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_for_jruby_download(host):
    f = host.file('/jruby-9.1.17.0')

    assert f.exists
    assert f.is_directory
