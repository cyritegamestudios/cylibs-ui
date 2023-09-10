## Setup
### 1. Install Homebrew   
Allow you to install dependencies  
`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
### 2. Install Lua
Allows you to run Lua tests locally  
`brew install lua`
 
## Run tests
To run the entire test suite:  
```
cd `cylibs/tests`
lua run_tests.lua
```
