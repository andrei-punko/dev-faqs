# Certificates

## Generating a Keystore (PKCS12 format) with self-signed certificate
According to [article](https://www.baeldung.com/spring-boot-https-self-signed-certificate)

```
keytool -genkeypair -alias andd3dfx -keyalg RSA -keysize 2048 -storetype PKCS12 -keystore andd3dfx.p12 -validity 365
```

Указываем параметры:
```
	Enter keystore password: `andreika`
	Re-enter new password: `andreika`
	What is your first and last name?
	  [Unknown]:  localhost
	What is the name of your organizational unit?
	  [Unknown]:  
	What is the name of your organization?
	  [Unknown]:  andrei-company
	What is the name of your City or Locality?
	  [Unknown]:  Minsk
	What is the name of your State or Province?
	  [Unknown]:  Minsk
	What is the two-letter country code for this unit?
	  [Unknown]:  BY
	Is CN=Andrei Punko, OU=andrei-dev, O=andrei-dev, L=Minsk, ST=Minsk, C=BY correct?
	  [no]:  yes
```

## View P12 certificate information on screen
```
openssl$ openssl pkcs12 -info -in andd3dfx.p12 -nodes
```

Получаем результат:
```
	Bag Attributes
		friendlyName: andd3dfx
		localKeyID: 54 69 6D 65 20 31 36 35 30 34 34 31 37 38 32 39 35 38
	subject=C = BY, ST = Minsk, L = Minsk, O = andrei-company, OU = Unknown, CN = articles-service

	issuer=C = BY, ST = Minsk, L = Minsk, O = andrei-company, OU = Unknown, CN = articles-service

	-----BEGIN CERTIFICATE-----
	MIIDhTCCAm2gAwIBAgIEJJ1Q1DANBgkqhkiG9w0BAQsFADBzMQswCQYDVQQGEwJC
	WTEOMAwGA1UECBMFTWluc2sxDjAMBgNVBAcTBU1pbnNrMRcwFQYDVQQKEw5hbmRy
	ZWktY29tcGFueTEQMA4GA1UECxMHVW5rbm93bjEZMBcGA1UEAxMQYXJ0aWNsZXMt
	...
	TbU5BHADEJHL4FQaQGGmQfm4yT1oo3o3jBJWu+MRvpBJGxX1gYiEElGBhnGpp+pU
	j7sMjXy9dU/UYCn6/yKSOQTT2F/oTmqx5iTMJOtRhAg/i4tF4tlsBH5butZpZz1T
	w5fnEM4j4OeFviFCIMZFh09mdqdtEHo16w5k8X4CtAGMp2FtSpi9x/o=
	-----END CERTIFICATE-----
```

## Extract private key from a P12 file and write it to PEM file
```
openssl pkcs12 -in andd3dfx.p12 -nocerts -out andd3dfx.key
```
(used `andreika` as a password for all steps)

## Extract the certificate file (the signed public key) from the P12 file
```
openssl pkcs12 -in andd3dfx.p12 -clcerts -nokeys -out andd3dfx.crt
```
(used `andreika` as a password for all steps)

## Make call to protected service using `curl`
```
curl -v \
  --cacert andd3dfx.crt \
  --key andd3dfx.key \
  https://localhost:9082/api/v1/articles
```

## Make call to usual service using `curl`
```
curl http://localhost:9081/api/v1/articles
```

## Что такое корневой сертификат?
Корневой сертификат — часть ключа, которым центры сертификации подписывают выпущенные SSL-сертификаты. Выдавая корневой
сертификат, каждый такой центр гарантирует, что пользователи или организации, запросившие SSL, верифицированы и действия
с доменом легальны.
Если информация о корневом сертификате центра отсутствует в браузере, у сайта нет «поручителя», и браузер считает его
недостоверным. Так иногда происходит с самоподписанными сертификатами безопасности.
Однако одного корневого сертификата недостаточно. Чтобы конкретный домен считался защищенным, помимо корневого
сертификата необходимы промежуточный сертификат и индивидуальный сертификат домена, которые так же выдаются центром
сертификации при выпуске SSL. Достоверность промежуточных и «индивидуальных» сертификатов подтверждается корневым
сертификатом. Цепочка сертификатов, установленных на сайт, дает основание считать его «защищенным SSL-сертификатом» в
сети Интернет.

## Где взять корневой сертификат?
Получить в сертификационном центре.

## Могу ли я создать корневой сертификат самостоятельно?
Чтобы создать корневой сертификат самому, нужно получить статус сертификационного центра. Эта процедура связана со
значительными финансовыми затратами, поэтому в большинстве случаев мы рекомендуем обращаться к существующим центрам
сертификации.

## Удаление сертификатов пользователя с телефона Android
В поиске по настройкам набрать "Шифрование и учетные данные".
Там - "Надежные сертификаты" и "Учетные данные пользователя"
