#!/bin/bash

if [ $# -lt 1 ]
then
	echo -e "Использование: ./network.sh [КЛЮЧ]...\nВоспользуйтесь -h"
	exit 1
fi

while getopts ":hau:d:p:m:g:k:s:n:" opt
do
	case ${opt} in
	h) helpText="\
Использование: ./network.sh [КЛЮЧ]...

Доступные ключи:
-h  помощь
-a  вывод всех сетевых интерфейсов
-u  включение сетевых интерфейсов
    (Пример: -u lo enp2s0 - запустит интерфейс lo и enp2s0)
-d  выключение сетевых интерфейсов
    (Пример использования: -d lo enp2s0 - отключит интерфейс lo и enp2s0)
-i  установка IP для интерфейса
    (Пример: -p lo 127.0.0.1 - установит для интерфейса lo ip-адресс 127.0.0.1)
-m  установка mask для интерфейса
    (Пример: -m lo 255.0.0.0 - установит для интерфейса lo маску сети 255.0.0.0)
-g  установка gateway по умолчанию
    (Пример: -g 192.168.1.5 - добавит шлюз по умолчанию с адресом 192.168.1.5)
-k  убийство процесса по занимаемому порту
    (Пример: -k 9999 - убивает процесс, который использует порт 9999)
-n  отображение карты сети
    (Пример: -n localhost - выведет результаты сканирования сети localhost)
    
Авторы: Мельников Иван, Беседин Яков"
	    echo -e "$helpText";;		
	a) echo "Вывод всех сетевых интерфейсов"
		ifconfig -a;;
	u) echo "Включение сетевых интерфейсов"
		sudo ifconfig ${OPTARG} up;;
	d) echo "Выключение сетевых интерфейсов"
		sudo ifconfig ${OPTARG} down;;
	i) echo "Установка IP для интерфейса ${OPTARG}"
		echo "Введите устанавливаемый IP: "
		read my_ip;
		sudo ifconfig ${OPTARG} ${my_ip};;
	m) echo "Установка mask для интерфейса ${OPTARG}"
		echo "Введите устанавливаемый mask: "
		read my_mask;
		sudo ifconfig ${OPTARG} netmask ${my_mask};;
	g) echo "Установка шлюза по умолчанию с адресом ${OPTARG}"
		route add default gw ${OPTARG};;
	k) processname=$(sudo netstat -lnup | grep :${OPTARG} | awk '{print($6)}' | cut -f 2 -d '/' |tail -1)
		PID=$(pidof $processname)
		# echo "$processname"
		# echo "$PID"
	    # processname=$(lsof -i -P -n | grep ${OPTARG} | awk '{print($1)}' | tail -1)
		# PID=$(pidof $processname)
		kill -9 $PID
		echo "Убийство процесса \"$processname\" который занимает порт $PID";;
	s) echo "Сетевая статистика (статистика использования трафика)"
		cat /proc/net/dev;;
	n) echo "Карта сети для ${OPTARG}"
		nmap -A -T 5 ${OPTARG};;
		# sudo nmap -sV -T 5 ${OPTARG};;
	*) echo -e "Использование: ./network.sh [КЛЮЧ]...\nВоспользуйтесь -h";;
esac
done