up:
	@docker-compose -f docker-compose.yml up -d
down:
	@docker-compose -f docker-compose.yml down
logs:
	@docker-compose -f docker-compose.yml logs -f
build:
	@docker build --build-arg RAILS_MASTER_KEY=$(cat config/master.key) -f Dockerfile -t simplesave-api:latest .
run:
	@rails s