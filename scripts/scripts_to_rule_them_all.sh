#!/usr/bin/env bash

# If your scripts are normalized by name across all of your projects,
# your contributors only need to know the pattern, not a deep knowledge
# of the application. This means they can jump into a project and make 
# contributions without first learning how to bootstrap the project or 
# how to get its tests to run.

# The intricacies of things like test commands and bootstrapping can be 
# managed by maintainers, who have a rich understanding of the project's
# domain. Individual contributors need only to know the patterns and 
# can simply run the commands and get what they expect.

SCRIPTS_FOLDER="script"

[ -d "$SCRIPTS_FOLDER" ] || mkdir "$SCRIPTS_FOLDER"

cat > "$SCRIPTS_FOLDER/bootstrap" << "EOF" 
#!/usr/bin/env bash

# script/bootstrap: Resolve all dependencies that the application requires to
#                   run.
# This can mean RubyGems, npm packages, Homebrew packages, Ruby versions, Git submodules, etc.
# The goal is to make sure all required dependencies are installed.

set -e

cd "$(dirname "$0")/.."
EOF

cat > "$SCRIPTS_FOLDER/setup" << "EOF" 
#!/usr/bin/env bash

# script/setup: Set up application for the first time after cloning, or set it
#               back to the initial first unused state.
# This is also useful for ensuring that your bootstrapping actually works well.

set -e

cd "$(dirname "$0")/.."
script/bootstrap
EOF

cat > "$SCRIPTS_FOLDER/update" << "EOF" 
#!/usr/bin/env bash

# script/update: Update application to run for its current checkout.
# If you have not worked on the project for a while, running 
# script/update after a pull will ensure that everything inside the 
# project is up to date and ready to work.

set -e

cd "$(dirname "$0")/.."
script/bootstrap
EOF

cat > "$SCRIPTS_FOLDER/server" << "EOF" 
#!/usr/bin/env bash

# script/server: Launch the application and any extra required processes
#                locally.

set -e

cd "$(dirname "$0")/.."

# ensure everything in the app is up to date.
script/update
EOF

cat > "$SCRIPTS_FOLDER/test" << "EOF" 
#!/usr/bin/env bash

# script/test: Run test suite for application. Optionally pass in a path to an
#              individual test file to run a single test.

set -e

cd "$(dirname "$0")/.."

[ -z "$DEBUG" ] || set -x

if [ "$APP_ENV" = "test" ]; then
  # if executed and the environment is already set to `test`, then we want a
  # clean from scratch application. This almost always means a ci environment,
  # since we set the environment to `test` directly in `script/cibuild`.
  script/setup
else
  # if the environment isn't set to `test`, set it to `test` and update the
  # application to ensure all dependencies are met as well as any other things
  # that need to be up to date, like db migrations. The environment not having
  # already been set to `test` almost always means this is being called on its
  # own from a `development` environment.
  export APP_ENV="test"

  script/update
fi

echo "==> Running tests..."
EOF

cat > "$SCRIPTS_FOLDER/cibuild" << "EOF" 
#!/usr/bin/env bash

# script/cibuild: Setup environment for CI to run tests. This is primarily
#                 designed to run on the continuous integration server.

set -e

cd "$(dirname "$0")/.."

echo "Tests started at…"
date "+%H:%M:%S"

export APP_ENV="test"

# run tests.
echo "Running tests…"
date "+%H:%M:%S"
script/test
EOF

cat > "$SCRIPTS_FOLDER/console" << "EOF" 
#!/usr/bin/env bash

# script/console: Launch a console for the application. Optionally allow an
#                 environment to be passed in to let the script handle the
#                 specific requirements for connecting to a console for that
#                 environment.

set -e

cd "$(dirname "$0")/.."

if [ -n "$1" ]; then
  case "$1" in
    production )  echo "Coonect to production console"                            ;;
    staging )     echo "Coonect to production console"                            ;;
    *)            echo "Sorry, I don't know to connect to the '$1' environment"; exit 1   ;;
  esac
else
  # no argument provided, so just run the local console in the development
  # environment. Ensure the application is up to date first.
  script/update
  #run th console in the development mode here.
fi
EOF

cd $SCRIPTS_FOLDER && chmod +x bootstrap cibuild console server setup "test" update
