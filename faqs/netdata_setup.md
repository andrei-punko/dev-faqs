# Настройка netdata

## Установка
```bash
wget -O /tmp/netdata-kickstart.sh https://get.netdata.cloud/kickstart.sh && sh /tmp/netdata-kickstart.sh --stable-channel --non-interactive
```

Флаги:
--stable-channel — стабильный релиз (по умолчанию nightly)
--non-interactive — без вопросов

## Проброс порта Netdata через SSH-туннель:
```bash
ssh -i "<PATH_TO_DIR_WITH_PEM_FILE>\pem_file_name.pem" -L 19999:localhost:19999 ubuntu@VM_IP_ADDRESS
```

После подключения откройте в браузере: http://localhost:19999
