#!/bin/bash

if [ $# -lt 1 ]
then
	echo "Воспользуйтесь -h"
	exit 1
fi

while getopts ":hau:d:p:m:g:k:s:n" opt
do
	case ${opt} in
	h)
			echo "Доступные аргументы: "
			echo -e "\n-h\tпомощь\n"
			echo -e "\n-a\tвывод всех сетевых интерфейсов\n"
			echo -e "\n-u\tвключение сетевых интерфейсов\n"
			echo "   Пример использования: -u lo enp2s0 - запустит интерфейс lo и enp2s0"
			echo -e "\n-d\tвыключение сетевых интерфейсов\n"
			echo "   Пример использования: -d lo enp2s0 - отключит интерфейс lo и enp2s0"
			echo -e "\n-p\tустановка IP для интерфейса\n"
			echo "   Пример использования: -p lo 127.0.0.1 - установит для интерфейса lo ip-адресс 127.0.0.1"
			echo -e "\n-m\tустановка mask для интерфейса\n"
			echo "   Пример использования: -m lo 255.0.0.0 - установит для интерфейса lo маску сети 255.0.0.0"
			echo -e "\n-g\tустановка gateway по умолчанию\n"
			echo "   Пример использования: -g 192.168.1.5 - добавит шлюз по умолчанию с адресом 192.168.1.5"
			echo -e "\n-k\tубийство процесса по занимаемому порту\n"
			echo "   Пример использования: -k 9999 - убивает процесс, который использует порт 9999"
			echo -e "\n-s\tотображение сетевой статистики (статистика использования трафика)\n"
			echo -e "\n-n\tотображение карты сети\n"
			echo "   Пример использования: -n localhost - выведет результаты сканирования сети localhost"
			echo -e "\nОпции можно группировать в любом порядке, пример:\n"
			echo "    -u lo enp2s0 -d wlp3s0 -h - запустит интерфейсы lo и enp2s0, отключит интерфейс wlp3s0 и отобразит подсказки"
			echo "Авторы: Мельников Иван, Беседин Яков";;		
	a) echo "Вывод всех сетевых интерфейсов"
		ifconfig -a;;
	u) echo "Включение сетевых интерфейсов"
		while true;
		do
			shift
			if [[ ${1} == "" ]]
			then
				break
			fi			
			if [[ ${1} =~ ^-[a-zA-Z]$ ]]
			then
				OPTIND=$OPTIND-2
				break
			fi
			ifconfig ${1} up
		done;;
	d) echo "Выключение сетевых интерфейсов"
		while true;
		do
			shift
			if [[ ${1} == "" ]]
			then
				break
			fi			
			if [[ ${1} =~ ^-[a-zA-Z]$ ]]
			then
				OPTIND=$OPTIND-2
				break
			fi
		    ifconfig ${1} down
		done;;
	p) echo "Установка IP для интерфейса ${OPTARG}"
		echo "Введите устанавливаемый IP: "
		read my_ip;
		ifconfig ${OPTARG} ${my_ip};;
	m) echo "Установка mask для интерфейса ${OPTARG}"
		echo "Введите устанавливаемый mask: "
		read my_mask;
		ifconfig ${OPTARG} netmask ${my_mask};;
	g) echo "Установка шлюза по умолчанию с адресом ${OPTARG}"
		route add default gw ${OPTARG};;
	k) echo "Убийство процесса который занимает порт ${OPTARG}"
		kill -9 ${OPTARG};;
	s) echo "Сетевая статистика (статистика использования трафика)"
		cat /proc/net/dev;;
	n) echo "Карта сети для ${OPTARG}"
		nmap -A ${OPTARG};;
	*) echo "Воспользуйтесь -h";;
esac
done