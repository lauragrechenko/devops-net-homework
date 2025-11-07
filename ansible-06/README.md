# Домашнее задание к занятию 6 «Создание собственных модулей»

[Ссылка на созданную ansible-galaxy collection: обязательная часть задания](https://github.com/lauragrechenko/net-devops-learning/tree/v1.0.0/learning)

## Подготовка к выполнению

1. Создайте пустой публичный репозиторий в своём любом проекте: `my_own_collection`.
2. Скачайте репозиторий Ansible: `git clone https://github.com/ansible/ansible.git` по любому, удобному вам пути.
3. Зайдите в директорию Ansible: `cd ansible`.
4. Создайте виртуальное окружение: `python3 -m venv venv`.
5. Активируйте виртуальное окружение: `. venv/bin/activate`. Дальнейшие действия производятся только в виртуальном окружении.
6. Установите зависимости `pip install -r requirements.txt`.
7. Запустите настройку окружения `. hacking/env-setup`.
8. Если все шаги прошли успешно — выйдите из виртуального окружения `deactivate`.
9. Ваше окружение настроено. Чтобы запустить его, нужно находиться в директории `ansible` и выполнить конструкцию `. venv/bin/activate && . hacking/env-setup`.

## Основная часть

Ваша цель — написать собственный module, который вы можете использовать в своей role через playbook. Всё это должно быть собрано в виде collection и отправлено в ваш репозиторий.

**Шаг 1.** В виртуальном окружении создали новый `dev_write_module.py` файл.

**Шаг 2.** Наполнили его содержимым [из статьи](https://docs.ansible.com/ansible/latest/dev_guide/developing_modules_general.html#creating-a-module).

**Шаг 3.** Заполнили файл в соответствии с требованиями Ansible так, чтобы он выполнял основную задачу: module должен создавать текстовый файл на удалённом хосте по пути, определённом в параметре `path`, с содержимым, определённым в параметре `content`.

**Шаг 4.** Проверили module на исполняемость локально.
Результаты запусков:
![alt text](screenshots/01.png)
Результаты `ansible-test sanity dev_write_module`:
![alt text](screenshots/02.png)
Результаты `ansible-test` после исправления всех ошибок:
![alt text](screenshots/03.png)

**Шаг 5.** Написали single task playbook и использовали module в нём.
![alt text](screenshots/04.png)

**Шаг 6.** Проверили через playbook на идемпотентность.
![alt text](screenshots/05.png)

**Шаг 7.** Вышли из виртуального окружения.

**Шаг 8.** Инициализоровали новую collection: `ansible-galaxy collection init netology_devops.learning`.

**Шаг 9.** В эту collection перенесли свой module в соответствующую директорию `plugins/modules`.

**Шаг 10.** Single task playbook преобразовали в single task role `dev_write` и перенесли в collection. У role должны быть default всех параметров module.

**Шаг 11.** Создали playbook для использования этой role.

**Шаг 12.** Заполнили всю документацию по collection, выложили в [свой репозиторий](https://github.com/lauragrechenko/net-devops-learning.git), поставили тег `1.0.0` на этот коммит.

**Шаг 13.** Создали .tar.gz этой collection: `ansible-galaxy collection build` в корневой директории collection.

**Шаг 14.** Создали ещё одну директорию любого наименования, перенесли туда single task playbook и архив c collection.

**Шаг 15.** Установили collection из локального архива: `ansible-galaxy collection install netology_devops-learning-1.0.0.tar.gz`.
![alt text](screenshots/06.png)

**Шаг 16.** Запустили playbook, убедились, что он работает.
![alt text](screenshots/07.png)
![alt text](screenshots/08.png)

**Шаг 17.** В ответ необходимо прислать ссылки на collection и tar.gz архив, а также скриншоты выполнения пунктов 4, 6, 15 и 16.

## Необязательная часть

[Ссылка на созданную ansible-galaxy collection (включающая yc_instance)](https://github.com/lauragrechenko/net-devops-learning/tree/v1.1.0/learning)

1. Реализовали свой модуль для создания хостов в Yandex Cloud.
2. Модуль имеент зависимость от `yc`, основной функционал: создание ВМ с нужным сайзингом на основе нужной ОС.
3. Модуль может формировать динамическое inventory.
4. Протестировали модуль на идемпотентность, исполнимость. Добавили этот модуль в свою коллекцию.
![alt text](screenshots/09.png)

![alt text](screenshots/10.png)

![alt text](screenshots/11.png)

5. Изменили playbook так, чтобы он умел создавать инфраструктуру под inventory, а после устанавливал весь стек Observability на нужные хосты и настраивал его.
![alt text](screenshots/12.png)

6. В итоге коллекция обязательно содержит: clickhouse-role, lighthouse-role, vector-role, два модуля: `dev_write_module` и модуль `yc_instance` управления Yandex Cloud хостами и playbook, который демонстрирует создание Observability стека.
![alt text](screenshots/13.png)
![alt text](screenshots/14.png)
---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
