# Copyright 2017 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


"""Create VM with a single disk.

Creates a Persistent Disk. Then creates an instance that attaches
that Persistent Disk as the boot disk.
"""

COMPUTE_URL_BASE = 'https://www.googleapis.com/compute/v1'


def GenerateConfig(context):
  """Create instance with disks."""

  bootdisk = 'gcp-disk-' + context.properties['zone']

  resources = [{
      'type': 'compute.v1.disk',
      'name': bootdisk,
      'properties': {
          'zone': context.properties['zone'],
          'sizeGb': 10,
          # Disk type is a full URI. Uses pd-standard; can be pd-ssd.
          'type': '/'.join([COMPUTE_URL_BASE,
                            'projects', context.properties['project_id'],
                            'zones', context.properties['zone'],
                            'diskTypes/pd-standard']),
          'sourceImage': '/'.join([COMPUTE_URL_BASE,
                                   'projects', 'debian-cloud', 'global',
                                   'images/family/debian-9']),
          'users': [
              '/'.join([COMPUTE_URL_BASE,
                        'projects', context.properties['project_id'],
                        'zones', context.properties['zone'],
                        'instances', 'gcp-vm-' + context.properties['zone']]),
          ],
      }
  }, {
      'type': 'compute.v1.instance',
      'name': 'gcp-vm-' + context.properties['zone'],
      'properties': {
          'zone': context.properties['zone'],
          'description': '',
          'machineType': '/'.join([COMPUTE_URL_BASE,
                                   'projects', context.properties['project_id'],
                                   'zones', context.properties['zone'],
                                   'machineTypes',
                                   context.properties['instance_type']]),
      'metadata': {},
          'disks': [{
              'deviceName': 'boot',
              'type': 'PERSISTENT',
              'boot': True,
              'autoDelete': True,
              'index': 0,
              'interface': 'SCSI',
              'mode': 'READ_WRITE',
              'source': '$(ref.' + bootdisk + '.selfLink)',
          }],
          'canIpForward': False,
          'networkInterfaces': [{
              'name': 'nic0',
              'network': '/'.join([COMPUTE_URL_BASE,
                                   'projects', context.properties['project_id'],
                                   'global/networks/default']),
              'accessConfigs': [{
                  'name': 'External NAT',
                  'type': 'ONE_TO_ONE_NAT'
              }]
          }],
          'scheduling': {
              'automaticRestart': True,
              'onHostMaintenance': 'MIGRATE',
              'preemptible': False,
          },
          'startRestricted': False,
      }
  }]
  return {'resources': resources}
