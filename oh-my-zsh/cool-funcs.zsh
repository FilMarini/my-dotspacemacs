## SMART SSH
smart_ssh(){
local port=$1
local ip=$2
local gate=$3
local bwname=$4
local remotehome=$5
local mountpoint=$6
if [[ -z "$5" ]] ; then
  if ssh -o ConnectTimeout=1 fmarini@$ip -YC 2>/dev/null; then
    :
  else
    if nc -z localhost $port &>/dev/null
    then
      ssh fmarini@localhost -p $port -YC
    else
      bw-cp $bwname
      (ssh -fN -L $port:$ip:22 fmarini@$gate; ssh fmarini@localhost -p $port -YC;)
    fi
  fi
else
  if mountpoint $mountpoint &>/dev/null ; then
    if ssh -o ConnectTimeout=1 fmarini@$ip -YC 2>/dev/null; then
      :
    else
      ssh fmarini@localhost -p $port -YC;
    fi
  else
    if sshfs -o ConnectTimeout=1 fmarini@$ip:$remotehome $mountpoint &>/dev/null ; then
      ssh fmarini@$ip -YC
    else
      if nc -z localhost $port &>/dev/null
      then
        sshfs fmarini@localhost:$remotehome $mountpoint -p $port
        ssh fmarini@localhost -p $port -YC
      else
        bw-cp $bwname
        ssh -fN -L $port:$ip:22 fmarini@$gate
        sshfs fmarini@localhost:$remotehome $mountpoint -p $port
        ssh fmarini@localhost -p $port -YC
      fi
    fi
  fi
fi
}

# BITWARDEN
bw-cp () {
local name=$1
local char_num=($(echo -n $name | wc -m));
local items=$(bw list items --search $name | jq '.[] | select(.name | match("'$name'"; "i"))');
local items_num=$(echo $items | jq -s '. | length');
if [[ $items_num -eq 1 ]]
then
    local passq=$(echo $items | jq '.login.password');
elif [[ $items_num -gt 1 ]]
then
    local passq=$(echo $items | jq '. | select(.name | length=='$char_num')' | jq '.login.password');
else
    echo "Nothing found..."
fi
local pass=$(echo $passq | xargs) ;
(echo -n $pass | xclip -se c;) }

bw-cu () {
local name=$1
local passq=$(bw list items --search $name | jq '.[0].name');
local num_out=$(bw list items --search $name | jq '.[] | select(.name | match("'$name'"; "i"))' | jq -s '. | length');
local pass=$(echo $passq | xargs) ;
(echo -n $pass | xclip -se c;) }

bw-ls-s () { bw list items --search $1 | jq -r '.[]?.name'; }
