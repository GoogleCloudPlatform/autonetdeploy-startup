/*
 * Copyright 2017 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


/*
 * Terraform compute resources for GCP.
 * Acquire all zones and choose one randomly.
 */

data "google_compute_zones" "available" {
  region = "${var.gcp_region}"
}

resource "google_compute_instance" "gcp-vm" {
  name         = "gcp-vm-${var.gcp_region}"
  machine_type = var.gcp_instance_type
  zone         = data.google_compute_zones.available.names[0]

  boot_disk {
    initialize_params {
      image = var.gcp_disk_image
    }
  }

  network_interface {
    network = "default"

    access_config {
      # Ephemeral IP
    }
  }
}
