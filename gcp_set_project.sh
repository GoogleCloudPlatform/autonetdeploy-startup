#!/bin/bash

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


# Add GCP project to configuration files.

# Check function arguments for project.
# arguments: project
function checkArgs () {
  if [ -z "$1" ]; then
    echo "Error: missing argument. $0 <GCP project_id>"
    exit 1
  fi
}


# Update project_id in DM config file.
# arguments: project_id dm_project_file
function fixDMProject() {
  local DM_PROJECT_FILE="${2}"
  local SED_EX="s/project_id: .*/project_id: $1/"
  sed -i -e "${SED_EX}" ${DM_PROJECT_FILE}
  echo "Updated project_id: ${1} in ${DM_PROJECT_FILE}."
}


# Start a new terraform.tfvars file.
# arguments: full_path_file_name.
function createTFVars() {
  if [ ! -e $1 ]; then
    echo "/*" > $1
    echo " * Initialized Terraform variables." >> $1
    echo " */" >> $1
  fi
}


# If not already present, add a key-value to tfvars file.
# arguments: tfvars_path_file_name key value
function addTFVar() {
  if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo 'Error: missing argument for addTFVar().'
    exit 1
  fi

  local VAR_NAME="$2"
  local KEY_EXISTS="$(cat $1 | grep $2)"

  if [ -z "${KEY_EXISTS}" ]; then
    echo "" >> $1
    echo "$2 = \"$3\"" >> $1
    echo "Updated $2 in $1."
  fi
}


# Add projects to configuration file(s) if existing.
# arguments: project
function addProject() {
  local PROJECT_ID="$1"
  local THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  local DM_PROJECT_FILE='autonetdeploy_config.yaml'
  local DM_PROJECT_FILE_PATH="${THIS_DIR}/deploymentmanager/${DM_PROJECT_FILE}"
  local TFVARS_DIR_PATH="${THIS_DIR}/terraform"
  local TFVARS_FILE_PATH="${TFVARS_DIR_PATH}/terraform.tfvars"
  local NEXT18_DIR_PATH="${THIS_DIR}/next18"
  local NEXT18_FILE_PATH="${NEXT18_DIR_PATH}/terraform.tfvars"
  local TFVAR_PROJECT='gcp_project_id'

  checkArgs ${PROJECT_ID}

  if [ -e ${DM_PROJECT_FILE_PATH} ]; then
    fixDMProject ${PROJECT_ID} ${DM_PROJECT_FILE_PATH}
  fi

  # Always create terraform.tfvars file even if dir does not exist already.
  mkdir -p "${TFVARS_DIR_PATH}"
  createTFVars "${TFVARS_FILE_PATH}"
  addTFVar "${TFVARS_FILE_PATH}" "${TFVAR_PROJECT}" "${PROJECT_ID}"

  # Same treatment for next18 Terraform files.
  mkdir -p "${NEXT18_DIR_PATH}"
  createTFVars "${NEXT18_FILE_PATH}"
  addTFVar "${NEXT18_FILE_PATH}" "${TFVAR_PROJECT}" "${PROJECT_ID}"
}

addProject $(gcloud config get-value project 2> /dev/null)
