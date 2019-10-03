.PHONY: all build seed lint test run console profile derailed update_lsc attach clean

all: build run

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
	$(docker-compose) build
	$(docker-compose) run --rm web bash -c 'bundle install --jobs $$((`nproc` - 1)) && yarn install && rails db:migrate && skylight disable_dev_warning'
	@[ -e tmp/seed ] || make seed
	$(docker-compose) stop

seed:
	$(docker-compose) run --rm web bash -c "bundle exec rails db:seed"
	@echo "# The presence of this file tells the splits-io Makefile to not re-seed data." > tmp/seed

lint:
	git diff-tree -r --no-commit-id --name-only head origin/master | xargs $(docker-compose) run web rubocop --force-exclusion

test:
	$(docker-compose) run --rm -e RAILS_ENV=test web bundle exec rspec $(path)

run: # Run docker-compose up, but work around Ctrl-C sometimes not stopping containers. See https://github.com/docker/compose/issues/3317#issuecomment-416552656
	bash -c "trap '$(docker-compose) stop' EXIT; $(docker-compose) up"

console:
	$(docker-compose) run --rm web rails console

profile:
	$(docker-compose) run --rm -e RAILS_ENV=profiling web rake assets:precompile
	$(docker-compose) run --rm -e RAILS_ENV=profiling --service-ports web rails s
	$(docker-compose) run --rm -e RAILS_ENV=profiling web rake assets:clobber

derailed:
	$(docker-compose) run --rm -e RAILS_ENV=profiling $(env) web bundle exec derailed $(command)

update_lsc:
	$(docker-compose) run --rm web bundle exec rake update_lsc

attach:
	@echo Do not use ctrl + c to exit this session, use ctrl + p then ctrl + q
	$(docker) attach $(shell $(docker) ps | grep splits-io_$(container)_ | awk '{print $$1}')

clean:
	$(docker-compose) down
	rm -rf bundle/
	rm -rf node_modules/
	rm -f tmp/seed

superclean:
	$(docker-compose) down --volumes
	rm -rf tmp/seed node_modules bundle
	docker system prune --all --force
	docker builder prune --all --force
