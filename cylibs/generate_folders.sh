mkdir -p temp

directories=("actions/" "analytics/" "battle/" "conditions" "doc/" "entity/" "events/" "luaDocs/" "messages/" "metrics/" "networking/" "paths/" "res/" "socket/" "trust/" "util/")

for directory in "${directories[@]}" 
do
	cp -rf "$directory" temp/
done

cp Cylibs-Include.lua temp/
