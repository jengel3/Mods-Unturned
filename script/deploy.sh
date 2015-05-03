git reset --hard
git pull
npm install
./node_modules/bower/bin/bower install
rake assets:precompile RAILS_ENV=production
touch tmp/restart.txt