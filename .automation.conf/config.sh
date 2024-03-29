export TEMPEST_CONCURRENCY=16

if [[ -z "${KAYOBE_AUTOMATION_TEMPEST_CONF_OVERRIDES:+x}" ]] || [[ ! -e "${KAYOBE_AUTOMATION_TEMPEST_CONF_OVERRIDES}" ]]; then
    KAYOBE_AUTOMATION_TEMPEST_CONF_OVERRIDES="${KAYOBE_AUTOMATION_CONFIG_PATH}/tempest/tempest.overrides.conf"
fi

if [[ -f ${KAYOBE_AUTOMATION_REPO_ROOT}/etc/kolla/public-openrc.sh ]]; then
    export TEMPEST_OPENRC="$(< ${KAYOBE_AUTOMATION_REPO_ROOT}/etc/kolla/public-openrc.sh)"
fi

# This file is used to configure kayobe-automation.
# https://github.com/stackhpc/kayobe-automation/blob/main/README.md

# See: https://github.com/stackhpc/docker-rally/blob/master/bin/rally-verify-wrapper.sh for a full list of tempest parameters that can be overriden.
# You can override tempest parameters like so:
export TEMPEST_CONCURRENCY=4
# Specify single test whilst experimenting
#export TEMPEST_PATTERN="${TEMPEST_PATTERN:-tempest.api.compute.servers.test_create_server.ServersTestJSON.test_host_name_is_same_as_server_name}"

if [ ! -z ${KAYOBE_ENVIRONMENT:+x} ]; then
  KAYOBE_AUTOMATION_TEMPEST_CONF_OVERRIDES="${KAYOBE_AUTOMATION_CONFIG_PATH}/tempest/tempest-${KAYOBE_ENVIRONMENT}-${KAYOBE_AUTOMATION_TEMPEST_LOADLIST:-}.overrides.conf"

  # Check if loadlist specific overrides exist, if not fallback to environment overrides.
  if [ ! -e "${KAYOBE_AUTOMATION_TEMPEST_CONF_OVERRIDES}" ]; then
      KAYOBE_AUTOMATION_TEMPEST_CONF_OVERRIDES="${KAYOBE_AUTOMATION_CONFIG_PATH}/tempest/tempest-${KAYOBE_ENVIRONMENT}.overrides.conf"
  fi

  if [[ "$KAYOBE_ENVIRONMENT" =~ "aio" ]]; then
    # Seem to get servers failing to spawn with higher concurrency
    export TEMPEST_CONCURRENCY=1
  fi

  if [[ "$KAYOBE_ENVIRONMENT" =~ "habrok" ]]; then
    export TEMPEST_CONCURRENCY=32
  fi
  if [[ "$KAYOBE_ENVIRONMENT" =~ "merlin" ]]; then
    export TEMPEST_CONCURRENCY=12
  fi
fi

if [[ -z "${KAYOBE_AUTOMATION_TEMPEST_CONF_OVERRIDES:+x}" ]] || [[ ! -e "${KAYOBE_AUTOMATION_TEMPEST_CONF_OVERRIDES}" ]]; then
    KAYOBE_AUTOMATION_TEMPEST_CONF_OVERRIDES="${KAYOBE_AUTOMATION_CONFIG_PATH}/tempest/tempest.overrides.conf"
fi

if [[ -f ${KAYOBE_AUTOMATION_REPO_ROOT}/etc/kolla/public-openrc.sh ]]; then
    export TEMPEST_OPENRC="$(< ${KAYOBE_AUTOMATION_REPO_ROOT}/etc/kolla/public-openrc.sh)"
fi

if [ "${KAYOBE_AUTOMATION_TEMPEST_LOADLIST:-}"  == "baremetal" ]; then
  # Need to force baremetal specific flavors.
  KAYOBE_AUTOMATION_TEMPEST_CONF_OVERRIDES="${KAYOBE_AUTOMATION_CONFIG_PATH}/tempest/tempest-${KAYOBE_ENVIRONMENT}-baremetal.overrides.conf"
fi

KAYOBE_CONFIG_SECRET_PATHS_EXTRA=(
    "etc/kayobe/environments/$KAYOBE_ENVIRONMENT/inventory/group_vars/wazuh/wazuh-secrets.yml"
)

KAYOBE_CONFIG_VAULTED_FILES_PATHS_EXTRA=(
    "etc/kayobe/environments/$KAYOBE_ENVIRONMENT/kolla/config/cinder/cinder-backup/ceph.client.cinder-backup.keyring"
    "etc/kayobe/environments/$KAYOBE_ENVIRONMENT/kolla/config/cinder/cinder-backup/ceph.client.cinder.keyring"
    "etc/kayobe/environments/$KAYOBE_ENVIRONMENT/kolla/config/glance/ceph.client.glance.keyring"
    "etc/kayobe/environments/$KAYOBE_ENVIRONMENT/kolla/config/nova/ceph.client.cinder.keyring"
    "etc/kayobe/environments/$KAYOBE_ENVIRONMENT/kolla/config/cinder/cinder-volume/ceph.client.cinder.keyring"
)
