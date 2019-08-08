#!/usr/bin/env bash

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

function usage() {
  local just_help=$1
  local missing_required=$2
  local invalid_argument=$3
  local invalid_option=$4
  local invalid_value=

  local help="Usage: simplesamlphp-docker.sh [OPTIONS]

Manage your simplesamlphp docker environments.

Example: simplesamlphp-docker.sh --add --config=docker/config.yml --config=docker/development.yml --name=\"simplesamlphp-dev-ssp1\"

Options (* indicates it is required):"
  local help_options="    \-a ,\--add\ \ \[Add new environment]
    \-d ,\--delete\ \ \[Delete environment specified by --name]
    \-r ,\--run\ \ \[Run environment specified by --name]
    \-b ,\--build\ \ \[Build environment specified by --name]
   +\-c=,\--config=\<Parameter>\ \[Specify docker-compose configuration file(s) to use. Used by --add]
   *\-n=,\--name=\<Parameter>\ \[The name of the docker environment]
"

  if [[ "$missing_required" != "" ]]; then
    echo "Missing required argument: $missing_required"
  fi

  if [[ "$invalid_option" != "" ]] && [[ "$invalid_value" = "" ]]; then
    echo "Invalid option: $invalid_option"
  elif [[ "$invalid_value" != "" ]]; then
    echo "Invalid value: $invalid_value for option: --$invalid_option"
  fi

  echo -e "
"
  echo "$help"
  echo "$help_options" | column -t -s'\'
  return
}

function init_args() {
  REQ_ARGS=("name")

  # get command line arguments
  POSITIONAL=()
  for key in "$@"; do

    case ${key} in
    -a | --add)
      #add="true"
      op="add"
      shift
      ;;
    -d | --delete)
      #delete="true"
      op="delete"
      shift
      ;;
    -r | --run)
      #run="true"
      op="run"
      shift
      ;;
    -b | --build)
      #build="true"
      op="build"
      shift
      ;;
    -c=* | --config=*)
      config+=("${key#*=}")
      shift
      ;;
    -n=* | --name=*)
      name="${key#*=}"
      shift
      ;;
    *)
      POSITIONAL+=("$key") # saves unknown option in array
      shift
      ;;
    esac
  done

  for i in "${REQ_ARGS[@]}"; do
    # $i is the string of the variable name
    # ${!i} is a parameter expression to get the value
    # of the variable whose name is i.
    req_var=${!i}
    if [[ "$req_var" = "" ]]; then
      usage "" "--$i"
      exit
    fi
  done
}

function copy_configs() {
  config_templates_dir="$SCRIPTPATH/simplesamlphp/config-templates"
  metadata_templates_dir="$SCRIPTPATH/simplesamlphp/metadata-templates"

  mkdir -p "$1/config" && cp -t "$1/config" "$config_templates_dir/*"
  mkdir -p "$1/metadata" && cp -t "$1/metadata" "$metadata_templates_dir/*"
}

function docker_compose() {
  docker-compose --project-name "$1" \
    --project-directory "$2"

}

init_args "$@"
CONF_PATH=${SCRIPTPATH}/ssamlphp_configs/${name}
if [[ -d "$CONF_PATH" ]]; then
  CONF_EXISTS="1"
fi

case ${op} in
add)
  if [[ -n ${CONF_EXISTS} ]]; then
    (>&2 echo "Configuration '$name' already exist")
    exit 1
  fi
  mkdir -p "$CONF_PATH"
  copy_configs "$CONF_PATH"
  ;;
delete)
  if [[ -z ${CONF_EXISTS} ]]; then
    (>&2 echo "Configuration '$name' does not exist")
    exit 1
  fi
  rm -rf "$CONF_PATH"
  ;;
build)

  ;;
run)
  ;;
esac

echo "$CONF_PATH"
