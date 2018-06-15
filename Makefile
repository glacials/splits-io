.PHONY: all build lint test run console update_lsc clean

all: build lint test run

ifeq ($(OS),Windows_NT)
  detectedOS := Windows
else
  detectedOS := $(shell sh -c 'uname -s 2>/dev/null || echo not')
endif

docker-compose := docker-compose
ifeq ($(detectedOS),Linux)
  docker-compose := sudo -E docker-compose
endif

build:
	$(docker-compose) build

lint:
	git diff-tree -r --no-commit-id --name-only head origin/master | xargs $(docker-compose) run web rubocop --force-exclusion

test:
	$(docker-compose) run -e RAILS_ENV=test web rspec

run:
	$(docker-compose) up

console:
	$(docker-compose) run web rails console

update_lsc:
	$(docker-compose) run web bundle exec rake update_lsc

clean:
	$(docker-compose) down
