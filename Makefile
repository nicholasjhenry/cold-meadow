start:
	docker-compose up -d

stop:
	docker-compose stop

db.console:
	docker-compose exec db psql -h localhost -U postgres

src.format:
	bundle exec rbprettier --write '{app,lib,spec}/**/*.rb'

demo.sms.reset:
	docker-compose exec db psql -h localhost -U postgres cold_meadow_development -c "truncate cold_meadow_messages;"

demo.sms.create:
	jq <<< `curl -X POST -H 'Content-Type: application/json' -d '{"message":{"uuid":"bafb6c01-1171-4f75-b488-c538c5aacd5a","recipients":[{"phone_number":"+15141234567"},{"phone_number":"+15141238950"}],"sender":{"personal_name":"Jane Smith"},"body":"Hello world!"}}' http://localhost:3000//cold_meadow/sms`

demo.sms.index:
	jq <<< `curl -X GET http://localhost:3000//cold_meadow/sms\?uuid\="bafb6c01-1171-4f75-b488-c538c5aacd5a"`