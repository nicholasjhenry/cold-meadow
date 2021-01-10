start:
	docker-compose up -d

stop:
	docker-compose stop

db.console:
	docker-compose exec db psql -h localhost -U postgres

src.format:
	bundle exec rbprettier --write '{app,lib,spec}/**/*.rb'