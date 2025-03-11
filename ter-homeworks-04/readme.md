# Задание 1
### Используя remote-модуль создали две ВМ для двух разных проектов marketing и analytics. 
### Настроили ssh и установку nginx в файле cloud-init.yml.

### Скриншот консоли ВМ yandex cloud с их метками
![task-1-1](./screenshots/image-1.png)

![task-1-2](./screenshots/image-2.png)

### Скриншот подключения к консоли и вывод команды sudo nginx -t
![task-1-3](./screenshots/image-3.png)

### Скриншот содержимого модуля module.test-vm
![task-1-4](./screenshots/image-4.png)

![task-1-5](./screenshots/image-5.png)

![task-1-6](./screenshots/image-6.png)

[Ссылка на коммит с изменениями](https://github.com/lauragrechenko/devops-net-homework/pull/5/commits/dc5661cd3357d9a3036e448ccdc288d5901e02f2)

---------------------

# Задание 2
### Написали локальный модуль vpc, который создает 2 ресурса: одну сеть и одну подсеть в зоне, объявленной при вызове модуля.
### Модуль возвращает в root module с помощью output информацию о yandex_vpc_subnet. 
### Скриншот информации из terraform console о модуле.
![task-2-6](./screenshots/image-7.png)
### Заменили ресурсы yandex_vpc_network и yandex_vpc_subnet созданным модулем. 
```
module "test_vpc" {
  source      = "./modules/vpc"
  vpc_name    = var.vpc_name
  subnet_cidr = var.default_cidr
  subnet_zone = var.default_zone
}
```

### Сгенерировали документацию к модулю с помощью terraform-docs.
```
laura-grechenko@Awesome-7560:~/learning/devops/net-course/devops-net-homework/ter-homeworks-04/src/modules/vpc$ docker run --rm --volume "$(pwd):/terraform-docs" -u $(id -u) quay.io/terraform-docs/terraform-docs:0.19.0 markdown /terraform-docs > terraform-docs.md
```

[Ссылка на коммит с изменениями](https://github.com/lauragrechenko/devops-net-homework/pull/5/commits/b7f0d600ce25a8c496b242942d4da0204b283c1e)


---------------------


# Задание 3
### Выведите список ресурсов в стейте.
![task-3-1](./screenshots/image-8.png)

### Полностью удалите из стейта модуль vpc.
![task-3-2](./screenshots/image-9.png)

### Полностью удалите из стейта модуль vm.
![task-3-3](./screenshots/image-10.png)

### Импортировали всё обратно. 
```
terraform import 'module.test_vm["marketing-vm"].yandex_compute_instance.vm[0]' 'fhmg10loqmh66rdunmg1'
terraform import 'module.test_vm["analytics-vm"].yandex_compute_instance.vm[0]' 'fhm38epga12l39i3avhq'
terraform import 'module.test_vpc.yandex_vpc_network.this' 'enpk8rt34cgtpsdiq5rv'
terraform import 'module.test_vpc.yandex_vpc_subnet.this' 'e9bsdca921osf4djg7q6'
```

### Проверили terraform plan. Значимых изменений нет. 
![task-3-4](./screenshots/image-11.png)

---------------------


# Задание 4
### Изменили модуль vpc для возможности создания подсети во всех зонах доступности, переданных в переменной типа list(object).
### Скриншот части плана.
![task-4-1](./screenshots/image-13.png)
### Output модуля.
![task-4-2](./screenshots/image-12.png)

[Ссылка на коммит с изменениями]()