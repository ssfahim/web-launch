setup:
	@make build
	@make up 
	@make composer-update
build:
	docker-compose build --no-cache --force-rm
stop:
	docker-compose stop
up:
	docker-compose up -d
composer-update:
	docker exec laravel-web bash -c "composer update"
data:
	docker exec laravel-web bash -c "php artisan migrate"
	docker exec laravel-web bash -c "php artisan db:seed"
create-laravel:
	docker exec -it laravel-web bash
	composer create-project laravel/laravel .
	exit
destroy-rebuild:
	docker-compose down --volumes --remove-orphans

	mkdir -p ./laravel-app
	
	docker-compose down --volumes --remove-orphans
	docker-compose build --no-cache
	docker-compose up -d

	docker exec -it laravel-web bash
	composer create-project laravel/laravel .

	php artisan config:clear
	php artisan route:clear
	php artisan view:clear
	php artisan cache:clear

	chown -R www-data:www-data .
	chmod -R 775 storage bootstrap/cache

	exit



