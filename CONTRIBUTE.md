2. How to bundle?
With ruby-nix, you shouldn't install gems using bundle. Nix will build the gems for you. Always run bundix to update your gemset after making changes to Gemfile.lock.. If you faced error with git fetch, set BUNDLE_PATH=vendor/bundle in your environment.

bundle add
run bundle add GEM --skip-install instead

bundle install (after modifying Gemfile)
run bundle lock instead

bundle update GEM
run bundle lock --update=GEM instead