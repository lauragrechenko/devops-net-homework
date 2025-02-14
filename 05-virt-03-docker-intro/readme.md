## Задача 1

[Ссылка на репозиторий Docker Hub](https://hub.docker.com/repository/docker/lauragrechenko/custom-nginx/general)

---

## Задача 2
#### 1-2. Запустили образ custom-nginx:1.0.0 согласно требованиям и переименовали
![alt text](image.png)

#### 3. Выполнили команды 
![alt text](image-2.png)

#### 4. Проверили доступ к индекс-странице
![alt text](image-3.png)

---

## Задача 3
#### 1-3. Подключились (attach) к контейнеру и нажали Ctrl-C
![alt text](image-1.png)
Когда мы подключаемся к контейнеру с помощью attach - мы напрямую подключаемся к главному процессу контейнера. При нажатие Ctrl-C процессу отправляется прерывающий сигнал (SIGINT) в результате чего главный процесс завершается и контейнер останавливается (т.к Docker контейнер работает только пока жив их основной процесс).

#### 4-6. Перезапустили контейнер и подключились к интерактивному терминалу (bin/bash)
![alt text](image-5.png)

#### 7-8. Изменили порт nginx с 80 на 81 и перезапустили nginx с новым конфигом
![alt text](<image-6.png>)
```
curl http://127.0.0.1:80
```
Ошибка Connection refused (Nginx больше не слушает порт 80).
```
curl http://127.0.0.1:81
```
Получили HTML-ответ от Nginx (он теперь работает на порту 81).

#### 9-10. Выполнили команды с хоста
![alt text](image-7.png)
Контейнер был запущен с `-p 8080:80`, Docker перенаправляет трафик с хоста (8080) на порт 80 внутри контейнера.
Но мы поменяли порт на 81 внутри контейнера, теперь 8080 на хосте ссылается на несуществующий порт.

#### 11. Исправили конфигурацию контейнера согласно инструкции
![alt text](<image-4.png>)

#### 12.  Удалили контейнер без остановки
![alt text](image-8.png)

---

## Задача 4
#### 1. Запустилм первый контейнер из образа centos и замонтировали каталог ($(pwd) в /data)
![alt text](image-9.png)

#### 2. Запустилм второй контейнер из образа debian и замонтировали каталог ($(pwd) в /data)
```
lgrechenko@Devops-VM:~/hw/05-virt-03-docker-intro$ docker run -d --name debian-container -v $(pwd):/data debian:latest sleep infinity
```

#### 3-5. Создали файлы на centos и хостовой машине. Проверили /data на debian
![alt text](image-10.png)

---

## Задача 5
#### 1. Создали 2 файла `compose.yaml` и `docker-compose.yaml`. Выполнили команду `docker compose up -d`
![alt text](image-11.png)
Compose поддерживает оба варианта имени файла: `compose.yaml` и `docker-compose.yaml`, но если оба файла присутствуют, приоритет отдается `compose.yaml`.

#### 2. Изменили файл compose.yaml так, чтобы были запущенны оба файла
![alt text](image-13.png)
Запустили оба контейнера
![alt text](image-12.png)

#### 3. Залили образ custom-nginx:latest в локальное registry
![alt text](image-14.png)
Проверили
![alt text](image-15.png)

#### 4-5. Настроили portainer и выбрав локальное окружение задеплоили компоуз с custom-nginx
![alt text](image-16.png)

Запущенный custom-nginx контейнер
![alt text](image-17.png)

#### 6. Часть конфигурации контейнера custom-nginx
![alt text](image-18.png)

#### 7. Удалили compose.yaml, исправили warning (Found orphan containers) и погасили compose-проект
![alt text](image-19.png)
`Found orphan containers` означает, что существуют контейнеры-сироты, которые до этого были частью compose-проекта, но теперь отсутствуют в compose.yaml (docker-compose.yaml).
С помощью флага мы удалили такие контейнеры автоматически `--remove-orphans`