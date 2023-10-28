up:

	docker-compose up --build -d
	docker-compose exec symfony composer install

down:

	docker-compose down

ps:

	docker-compose ps

bash:

	docker-compose exec symfony bash
