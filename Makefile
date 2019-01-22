.PHONY: all build lint test run console update_lsc clean

all: build seed lint test run console update_lsc attach clean

ifeq ($(OS),Windows_NT)
  detectedOS := Windows
else
  detectedOS := $(shell sh -c 'uname -s 2>/dev/null || echo not')
endif

docker-compose := docker-compose
docker := docker
ifeq ($(detectedOS),Linux)
  docker-compose := sudo -E docker-compose
  docker := sudo -E docker
endif

container ?= web

build:
	$(docker-compose) run web bundle install
	$(docker-compose) build
	$(docker-compose) run web rails db:migrate
	@[ -e tmp/seed ] || make seed

seed:
	$(docker-compose) run web bash -c "bundle exec rails db:migrate && bundle exec rails db:seed"
	@echo "# The presence of this file tells the splits-io Makefile to not re-seed data." > tmp/seed

lint:
	git diff-tree -r --no-commit-id --name-only head origin/master | xargs $(docker-compose) run web rubocop --force-exclusion

test:
	$(docker-compose) run -e RAILS_ENV=test web rspec $(path)

run: # Run docker-compose up, but work around Ctrl-C sometimes not stopping containers. See https://github.com/docker/compose/issues/3317#issuecomment-416552656
	bash -c "trap '$(docker-compose) stop' EXIT; $(docker-compose) up"

console:
	$(docker-compose) run web rails console

update_lsc:
	$(docker-compose) run web bundle exec rake update_lsc

attach:
	@echo Do not use ctrl + c to exit this session, use ctrl + p then ctrl + q
	$(docker) attach $(shell $(docker) ps | grep splits-io_$(container)_ | awk '{print $$1}')

clean:
	$(docker-compose) down
	rm -f tmp/seed
