### 1. Запустили playbook на окружении из test.yml, зафиксировали значение, которое имеет факт some_fact для указанного хоста при выполнении playbook.
### `some_fact` имеет значение 12.
![alt text](screenshots/1.png)

### 2. Нашли файл с переменными (group_vars), в котором задаётся найденное в первом пункте значение, и поменяли его на `all default fact`.
![alt text](screenshots/2.png)

### 3. Запустили 2 Docker контейнера `ubuntu` & `centos7` для проведения дальнейших испытаний.
![alt text](screenshots/4.png)

### 4. Запустили playbook на окружении из prod.yml. Зафиксировали полученные значения some_fact для каждого из managed host.
### для `deb(ubuntu)` — `deb`, для `el(centos7)` — `el`
![alt text](screenshots/3.png)

### 5. Добавили факты в group_vars каждой из групп хостов так, чтобы для some_fact получились значения: для `deb` — `deb default fact`, для `el` — `el default fact`.

### 6. Повторили запуск playbook на окружении prod.yml. Убедились, что выдаются корректные значения для всех хостов.
![alt text](screenshots/5.png)

### 7. При помощи ansible-vault зашифровали факты в group_vars/deb и group_vars/el с паролем `netology`.
![alt text](screenshots/7.png)

### 8. Запустили playbook на окружении prod.yml. При запуске ansible запросил пароль. Убедились в работоспособности.
![alt text](screenshots/6.png)

### 9. Посмотрели при помощи ansible-doc список плагинов для подключения. Выбрали `ansible.builtin.local` подходящий для работы на control node.
![alt text](screenshots/8.png)

### 10. В prod.yml добавили новую группу хостов с именем local, в ней разместили localhost с типом подключения `local`.
```
  local:
    hosts:
      localhost:
        ansible_connection: local
```

### 11. Запустили playbook на окружении prod.yml. При запуске ansible запросил пароль. Убедились, что факты some_fact для каждого из хостов определены из верных group_vars.
![alt text](screenshots/9.png)




------------------





### 1. При помощи ansible-vault расшифровали все зашифрованные файлы с переменными.
![alt text](screenshots/10.png)

### 2. Зашифровали отдельное значение PaSSw0rd для переменной some_fact паролем netology. 
![alt text](screenshots/11.png)

### Добавили полученное значение в group_vars/all/examp.yml.
![alt text](screenshots/12.png)

### 3. Запустили playbook, убедились, что для нужных хостов применился новый fact.
![alt text](screenshots/13.png)

### 4. Добавили новую группу хостов fedora, добавили для неё переменную. 
![alt text](screenshots/14.png)

### 5. Написали скрипт на bash: автоматизировав поднятие контейнеров, запуск ansible-playbook и остановку контейнеров.
```
#!/bin/bash
set -e

docker compose up -d

ansible-playbook -i playbook/inventory/prod.yml playbook/site.yml --vault-password-file <(echo netology)

docker compose down
```
### Результат выполнения скрипта.
![alt text](screenshots/15.png)
![alt text](screenshots/16.png)
