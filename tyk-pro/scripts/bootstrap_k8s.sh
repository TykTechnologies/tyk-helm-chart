#!/bin/bash

if [ -z "${2}" ]; then 
    ADMIN_TOKEN='12345'
else 
    ADMIN_TOKEN=${2}
fi

if [ -z "${3}" ]; then 
   echo "namespace is required"
   exit
else 
    NS=${3}
fi

main(){
  if [[ $# -lt 1 ]]
    then
      syntax_message
  elif [ -z $(which curl) ]
    then
      curl_message
  elif [ -z $(which python) ]
    then
      python_message
    else
      LOCALIP=$(check_host $1)
      RANDOM_USER=$(env LC_CTYPE=C tr -dc "a-z0-9" < /dev/urandom | head -c 10)
      PASS="t2e0s1T7"
      generate_credentials "$LOCALIP" $RANDOM_USER $PASS
      exit_reason "$?"
  fi
}

syntax_message() {
  echo 'SYNTAX ERROR: Usage `./bootstrap.sh DASHBOARD_HOSTNAME`'
  exit 1
}

curl_message() {
  echo 'ERROR: Please install cURL'
  exit 1
}

python_message() {
  echo 'ERROR: Please install Python and ensure that you are able to run the `python` command within the terminal'
  exit 1
}

check_host(){
  # [[ $1 == *:* ]] && echo "" || echo $1
  echo $1 
}

generate_credentials(){
  error=0
  [[ -z "$1" ]] && return "6" || echo ""
  error="$?"
  [[ $error != 0 ]] && return $error
  echo "Creating Organisation"
  ORGDATA=$(create_organisation $1)
  error="$?"
  [[ $error != 0 ]] && return $error || echo "ORG DATA: $ORGDATA"
  ORGID=$(org_id "$ORGDATA")
  error="$?"
  [[ $? != 0 ]] && return $error || echo "ORG ID: $ORGID"
  echo ""
  echo "Adding new user"
  USER_AUTH_CODE=$(create_user $1 $2 $3 $ORGID)
  error=$?
  [[ $error != 0 ]] && return $error || echo "USER AUTHENTICATION CODE: $USER_AUTH_CODE"
  USER=$(get_user $1 $USER_AUTH_CODE)
  error=$?
  [[ $? != 0 ]] && return $error
  USERID=$(get_user_id "$USER")
  error=$?
  [[ $error != 0 ]] && return $error || echo "NEW ID: $USERID"
  EMAIL=$(get_user_email "$USER")
  error=$?
  [[ $? != 0 ]] && return $error
  echo ""
  echo "Setting password"
  setting_password $1 $USER_AUTH_CODE $3
  error=$?
  [[ $? != 0 ]] && return $error

  output $1 $EMAIL $3
}

exit_reason(){
  case "$1" in
    "3")
      echo "ERROR: Unable to connect to the Dashboard. Please check that you are using the correct hostname."
      exit $1
      ;;
    "4")
      echo "ERROR: Unable to parse JSON"
      exit $1
      ;;
    "5")
      echo "Unexpected error"
      exit $1
      ;;
    "6")
      echo "ERROR: Hostname should not contain port number or protocol"
      ;;
    *)
      echo ""
      ;;
  esac
}

if_present_echo(){
  [[ -z "$1" ]] && return $2 || echo "$1"
}

create_organisation() {
  ORGDATA=$(curl --silent --header "admin-auth: $ADMIN_TOKEN" --header "Content-Type:application/json" --data '{"owner_name": "Default Org.","owner_slug": "default", "cname_enabled": true, "cname": ""}' http://$1/admin/organisations 2>&1)
  if_present_echo "$ORGDATA" 3
}

org_id(){
  ORGID=$(echo $1 | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["Meta"]')
  if_present_echo $ORGID 4
}


create_user(){
  USER_DATA=$(user_data $1 $2 $3 $4)
  AUTH_CODE=$(echo $USER_DATA | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["Message"]')
  if_present_echo "$AUTH_CODE" 4
}

user_data(){
  user_curl=$(curl --silent --header "admin-auth: $ADMIN_TOKEN" --header "Content-Type:application/json" --data '{"first_name": "Joan","last_name": "Smith","email_address": "'$2'@default.com","password":"'$3'", "active": true,"org_id": "'$4'"}' http://$1/admin/users 2>&1)
  if_present_echo $user_curl 3
}

get_user(){
  USER_LIST=$(get_user_list $1 $2)
  USER=$(get_last_user $USER_LIST)
  if_present_echo "$USER" 5
}

get_user_list(){
  list=$(curl --silent --header "authorization: $2" http://$1/api/users 2>&1)
  if_present_echo "$list" 3
}

get_user_id(){
  export user=$1
  id=$(python -c "import json,os,string;user_str=os.environ['user'];print json.loads(user_str)['id']")
  if_present_echo "$id" 4
}

get_user_email(){
  export user=$1
  email=$(python -c "import json,os,string;user_str=os.environ['user'];print json.loads(user_str)['email_address']")
  if_present_echo "$email" 4
}

get_last_user(){
  user_parsed=$(echo $1 | python -c 'import json,sys;obj=json.load(sys.stdin);print json.dumps(obj["users"][0])')
  if_present_echo "$user_parsed" 4
}

setting_password(){
  USER=$(get_user $1 $2)
  USERID=$(get_user_id "$USER")
  response=$(curl --silent --header "authorization: $2" --header "Content-Type:application/json" http://$1/api/users/$USERID/actions/reset --data '{"new_password":"'$3'"}')
  if_present_echo "$response" 3
}

output(){
  echo ""
  echo "DONE"
  echo "===="
  echo "Login at http://$1/"
  echo "User: $2"
  echo "Pass: $3"

  INFILE = ${PWD}/tyk-pro/scripts/secret_tpl.yaml
  OUTFILE = ${PWD}/tyk-pro/scripts/secrets.yaml
  B64_ORGID = $(echo -n ${ORGID} | base64)
  B64_CODE = $(echo -n ${USER_AUTH_CODE} | base64)

  sed -e "s/\${namespace}/${NS}/" -e "s/\${ORGID}/${B64_ORGID}/" -e "s/\${USER_AUTH_CODE}/${B64_CODE}/" ${INFILE} > ${OUTFILE}
}

main $1 $2
