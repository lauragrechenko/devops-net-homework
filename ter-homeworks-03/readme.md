# Задание 1
### Выполнили код и проверили входящие правила «Группы безопасности».
![task-1](./screenshots/image-0.png)


---------------------

# Задание 2
### Создали ВМ `web-1` и `web-2` используя `count loop`.

### Создали ВМ для баз данных с именами `main` и `replica` используя `for_each loop`.

---------------------

# Задание 3
### Создали 3 одинаковых виртуальных диска размером 1 Гб
### Создали ВМ `storage` и подключили созданные 3 дополнительных диска.


---------------------

# Итоговый результат по задания 1-3

### Созданные 5 ВМ
![task-2-3](./screenshots/image-1.png)

### Созданные 3 Виртуальные диски
![task-3](./screenshots/image-2.png)

### Проверили Группу безопасности (Security group) в ВМ `Web-1`.
![task-1-2](./screenshots/image-3.png)

---------------------
# Задание 4
### Создали файл-шаблон `hosts.tpl`

### Создали файл-шаблон `ansible.tf`

### Cкриншот получившегося файла `hosts.ini`
![task-4](./screenshots/image-4.png)

### [Ссылка на ветку terraform-03-tasks-1-4](https://github.com/lauragrechenko/devops-net-homework/pull/1/files)

---------------------
# Задание 5
### Cкриншот вывода:
![task-5](./screenshots/image-5.png)


---------------------
# Задание 6
### Используя `null_resource` и `local-exec`, применили `ansible-playbook` к ВМ из `ansible inventory-файла`. Готовый код взяли из демонстрации к лекции.

### Модифицировали файл-шаблон `hosts.tpl`: ansible_host="<внешний IP-address или внутренний IP-address если у ВМ отсутвует внешний адрес>.

### Для проверки убрали внешний IP адрес (nat=false) для `web-1`, `web-2`, `storage` и применили изменения:
```
laura-grechenko@Awesome-7560:~/learning/devops/net-course/devops-net-homework/ter-homeworks-03/src$ 
terraform apply -var 'vm_web_nat_enabled=false' -var 'vm_storage_nat_enabled=false'
```

### Проверили, что для `web-1`, `web-2`, storage используется внутренний IP:
![task-6](./screenshots/image-6.png)

### [Ссылка на ветку terraform-03-tasks-5-6](https://github.com/lauragrechenko/devops-net-homework/pull/2/files)