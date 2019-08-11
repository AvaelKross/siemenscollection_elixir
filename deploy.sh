 ssh apps@188.226.216.228 -p 5123 "cd siemenscollection_elixir/
     git pull origin master
     node node_modules/brunch/bin/brunch build --production
     MIX_ENV=prod mix deps.get
     MIX_ENV=prod mix ecto.migrate
     MIX_ENV=prod mix phoenix.digest
     MIX_ENV=prod mix compile
     MIX_ENV=prod rel/siemens_collection/bin/siemens_collection stop
     MIX_ENV=prod mix release
     MIX_ENV=prod rel/siemens_collection/bin/siemens_collection start"


# NEWER ONE
#. build.sh
#scp -P 5123 releases/siemens_collection/releases/0.0.1/siemens_collection.tar.gz apps@188.226.216.228:~/siemens_collection_server
#ssh apps@188.226.216.228 -p 5123 "cd siemens_collection_server/
#    MIX_ENV=prod bin/siemens_collection stop
#    tar -zxvf siemens_collection.tar.gz
#    MIX_ENV=prod bin/siemens_collection start"
