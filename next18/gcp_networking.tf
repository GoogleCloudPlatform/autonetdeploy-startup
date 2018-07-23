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
 * Terraform networking resources for GCP.
 */

resource "google_compute_network" "gcp-network" {
  name                    = "gcp-network"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "gcp-subnet1" {
  name          = "gcp-subnet1"
  ip_cidr_range = "${var.gcp_subnet1_cidr}"
  network       = "${google_compute_network.gcp-network.name}"
  region        = "${var.gcp_region}"
}
