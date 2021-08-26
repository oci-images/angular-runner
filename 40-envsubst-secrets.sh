#!/bin/sh

set -eu

ME=$(basename $0)
USER=$(whoami)

auto_envsubst() {
	
	filesnum=$(ls /usr/share/nginx/html/main.*.js | wc -l)
	if [ $filesnum = 1 ]; 
	then
		MAIN_FILE=$(ls /usr/share/nginx/html/main.*.js)
		env | while IFS= read -r line
		do
		  name="${line%%=*}"
		  indirect_presence="$(eval echo "\${$name+x}")"
		  [ -z "$name" ] || [ -z "$indirect_presence" ] || sed -i "s#\${$name}#$(eval echo "\$$name")#g" $MAIN_FILE 
		done
	else
		echo "No se Detecto Archivo main.*.js"
	fi
	
	filesnum=$(ls /usr/share/nginx/html/assets/env.template.js | wc -l)
	if [ $filesnum = 1 ]; 
	then
		envsubst < /opt/app-root/src/assets/env.template.js > /opt/app-root/src/assets/env.js
	else
		echo "No se Detecto Archivo /assets/env.template.js"
	fi	
	
}
auto_envsubst

exit 0