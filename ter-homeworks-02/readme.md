# Задание 1
### 1-2. Изучили проект. Использовали service-account и ключ созданный в предыдущей работе.
![Service-account](./screenshots/image.png)

Перемионовали файл и скопировали в `~/`, чтобы имя соответствовало имени указанному в `providers.tf`.
```
 service_account_key_file = file("~/.authorized_key.json")
```

```
laura-grechenko@Awesome-7560:~/learning/devops/net-course/devops-net-homework$ cat ~/.authorized_key.json 
{
   "id": "aje2t04hqhg8dsebnc9r",
   "service_account_id": "ajef76a4nps3asoeifqd",
   "created_at": "2025-02-24T12:42:06.668661870Z",
   "key_algorithm": "RSA_2048",
   "public_key": "YYYYYYYYYYYYYY",
   "private_key": "XXXXXXXXXXXXXXXXX"
}
```

### 3. Сгенерировали новый ssh-ключ. Записали его открытую(public) часть в переменную vms_ssh_root_key.
```
variable "vms_ssh_root_key" {
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIELR69LvbgRZaTyYcvL3f70oCf+l86UPTRG27wG6Vau0 laura-grechenko@Awesome-7560"
}
```

### 4. Исправили в `main.tf`
```
resource "yandex_compute_instance" "platform" {
    ...
  platform_id = "standart-v4"
  resources {
    cores         = 1
  }
  ...
}
```

`platform_id`, `cores` на 

```
resource "yandex_compute_instance" "platform" {
    ...
  platform_id = "standard-v2"
  resources {
    cores         = 2
  }
  ...
}
```
В имени допущена опечатка и версия 4 не найдена - выбрали платформу `standard-v2` из [Доступных платформ в YC](https://yandex.cloud/en/docs/compute/concepts/vm-platforms).

Исправили количество ядер на 2, т.к. 2 является [минимальным значением](https://yandex.cloud/en/docs/compute/concepts/performance-levels).

### Успешно выполнили код и проверили созданные ресурсы
![VM-1](./screenshots/image-1.png)
![VM-2](./screenshots/image-2.png)

### 5. Подключились к консоли ВМ через ssh и выполнили команду `curl ifconfig.me`
![Ssh-Connect](./screenshots/image-3.png)

### 6. Как в процессе обучения могут пригодиться параметры preemptible = true и core_fraction=5 в параметрах ВМ.

[`preemptible`](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance#preemptible-1) делает виртуальную машину прерываемой, то есть она может быть автоматически завершена в любой момент, если облаку понадобятся ресурсы.


[`core_fraction`](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance#core_fraction-1) определяет минимально гарантированную производительность процессора. Например, при `core_fraction = 5` инстанс гарантированно получает 5% от мощности vCPU, но может использовать больше, если ресурсы свободны.

 Использование таких параметров делает виртуальную машину **значительно дешевле** и позволяет экономить ресурсы при выполнение ДР.


----------------------------

 # Задание 2
 ### 1. 