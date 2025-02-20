# Задача 1
### 1-2. Создали fork репозиторий и `Dockerfile.python`.
[Ссылка на fork репозиторий](https://github.com/lauragrechenko/shvirtd-example-python)
[Ссылка на Dockerfile.python](https://github.com/lauragrechenko/shvirtd-example-python/blob/1f5db713c54f50c6e8b075e47cdc9b854d29d37c/Dockerfile.python)

-------------------

### 3. Запустили web-приложение без использования docker
![alt text](image-6.png)
![alt text](image-5.png)

### 4. Задали имя используемой таблицы через ENV переменную `DB_TABLE`
[Ссылка на main.py](https://github.com/lauragrechenko/shvirtd-example-python/blob/main/main.py#L12)

-------------------

# Задача 2
### Загрузили образ в yandex cloud и просканировали на уязвимости
![alt text](image.png)

-------------------

# Задача 3
### Создали compose-проект согласно описанной схеме. Результат работы SQL:
![alt text](image-1.png)
![alt text](image-2.png)

-------------------

# Задача 4
### Запустили в YC ВМ, прогнали трафик. Результат работы SQL:
![alt text](image-3.png)
![alt text](image-4.png)

[Ссылка на fork репозиторий](https://github.com/lauragrechenko/shvirtd-example-python)

[Ссылка на bash скрипт](https://github.com/lauragrechenko/shvirtd-example-python/blob/main/setup.sh)

[Ссылка на compose.yaml](https://github.com/lauragrechenko/shvirtd-example-python/blob/1f5db713c54f50c6e8b075e47cdc9b854d29d37c/compose.yaml)

-------------------

# Задача 5
## Создание бэкапа в ручную (script)
### При попытке запуска образа schnitzler/mysqldump согласно инструкции получили ошибку:
```
mysqldump: Got error: 1045: "Plugin caching_sha2_password could not be loaded: Error loading shared library /usr/lib/mariadb/plugin/caching_sha2_password.so: No such file or directory"
```
![alt text](<Screenshot from 2025-02-19 18-17-44.png>)

### Чтобы ее исправить, создали новый образ lauragrechenko/mysqldump-fixed на базе schnitzler/mysqldump, в котором установили необходимые зависимости:
![alt text](<Screenshot from 2025-02-19 18-15-59.png>)

### Залили образ на docker-hub:
![alt text](<Screenshot from 2025-02-19 18-16-51.png>)

### Используя образ, запустили создание бэкапов и проверили, что файл был создан:
![alt text](<Screenshot from 2025-02-19 18-12-35.png>)

### Backup script
```
#!/bin/sh

docker run --rm --entrypoint "" \
    -v /opt/backup:/opt/backup \
    --network shvirtd-example-python_backend \
    lauragrechenko/mysqldump-fixed \
    mysqldump --opt -h shvirtd-example-python-db-1 -u root -p"YtReWq4321" --result-file=/opt/backup/dumps.sql virtd

```
-------------------
## Создание бэкапа используя Cron
### По примеру в инструкции для образа schnitzler/mysqldump создали docker-compose.yaml, но использовали lauragrechenko/mysqldump-fixed
### Использоаали .env для хранения все переменных. Добавили .env в .dockerignore.
```
services:
  cron:
    image: lauragrechenko/mysqldump-fixed
    restart: always
    volumes:
      - ./bin/crontab:/var/spool/cron/crontabs/root  # Load cron jobs
      - ./bin/backup:/usr/local/bin/backup  # Backup script
      - /opt/backup:/backup  # Store backups
      - .env:/env/.env # Mount .env file

    env_file: .env
    networks:
      - shvirtd-example-python_backend
networks:
  shvirtd-example-python_backend:
    external: true
```
### Скрипт, cron-task и скриншот с несколькими резервными копиями в "/opt/backup"
![alt text](<Screenshot from 2025-02-19 21-25-49.png>)


# Задача 6 
### Используя `Dive` нашли слой, в котором добавляется `Terraform`, запомнили `digest = da25c3c268493bc8d...`
![alt text](<Screenshot from 2025-02-20 14-22-24.png>) 
### Используя `Docker save`, сохранили образ `Terraform` в архив tar:
![alt text](<Screenshot from 2025-02-20 14-40-02.png>)
### Нашли нужный слой `da25c3c268493bc8d...`
![alt text](<Screenshot from 2025-02-20 14-40-31.png>)
### Нашли и запустили `bin\terraform'
![alt text](<Screenshot from 2025-02-20 14-41-18.png>)

# Задача 6.1
### Скопировали используя 'docker cp' и запустили `bin\terraform'
![alt text](<Screenshot from 2025-02-20 15-09-06.png>)

# Задача 6.2
### Извлекли файл из контейнера, используя только команду docker build и Dockerfile. 
![alt text](<Screenshot from 2025-02-20 15-18-38.png>)
### Запустили `bin\terraform'
![alt text](<Screenshot from 2025-02-20 15-19-52.png>)
