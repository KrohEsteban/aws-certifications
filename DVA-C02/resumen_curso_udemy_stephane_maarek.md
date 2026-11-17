---
title: Resumen del curso
parent: DVA-C02
nav_order: 2
redirect_from:
  - /DVA-C02/resumen_curso_udemy_stephane_maarek.html
---

# Ultimate AWS Certified Developer Associate 2026 DVA-C02 - Stéphane Maarek

## IAM & AWS CLI

> 🔗 **Documentación oficial**: [AWS IAM User Guide](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html)

### Conceptos Básicos IAM

**IAM** = Identity and Access Management

- **Root Account**: Cuenta principal que solo debería usarse para crear otras cuentas y no se debería compartir con
  nadie
- **Usuarios**: Cuentas individuales que creas para personas y estas las puedes agrupar en diferentes grupos para
  darles permisos a todos a la vez
- **Grupos**: Colecciones de usuarios que permiten asignar políticas de forma masiva, facilitando la gestión de permisos
- **Roles**: Permite darle una política a un servicio especifico de AWS, para esto lo creamos en la sección de IAM pero
  tenemos que usarlo en nuestro servicio en cuestión
- **Políticas**: Documentos JSON que definen permisos específicos (Allow/Deny) para acciones en recursos de AWS, que se
  pueden adjuntar a usuarios, grupos o roles
- **Servicio Global**: IAM es un servicio global (no está limitado a una región)

### Identificación de Cuentas

**Root Account**:

- En la consola, en el desplegable superior derecho muestra solo un Account ID que es único y es el ID de la cuenta
  principal
- En el dashboard principal de IAM puedes crear un Account Alias para personalizar el sign-in URL para los usuarios que
  creaste

**Cuenta IAM**:

- Puedes ingresar sin la sign-in personalizada, en ese caso tienes que elegir que ingresas con una cuenta IAM
- Te pide 3 datos para ingresar: usuario, contraseña y ID. El ID que te pide al principio es el ID de la cuenta root o
  en el caso que le hayas puesto un alias sería el alias
- Una vez que ingreses en una cuenta IAM lo puedes verificar en el desplegable superior derecho que dice "IAM user:
  nombre del usuario" junto con el account ID

**Simultaneous Sign-in**:

- Puedes habilitar un simultaneous Sign-in para poder tener dos cuentas abiertas en el mismo navegador
- Se configura en el desplegable debajo del nombre de la cuenta (superior derecho)

**Acceso por consola (CLI)**:

- Para acceder por terminal se necesitan Access key y Access secret key
- Estas key las creamos desde un usuario en la sección de Security credentials
- También tenemos que crearlas en el mismo lugar cuando necesitamos conectar una aplicación a nuestros servicios, al
  crearla tenes que seleccionar entre varias opciones depende para que las uses
- Para poder utilizarlas hay que instalar los paquetes de AWS CLI y luego configurarlo con el comando `aws configure`
- Con CLI podemos hacer exactamente las mismas cosas que hacemos por consola
- En la consola hay un botón pegado al desplegable donde se eligen las regiones que te abre una terminal en el
  navegador llamado CloudShell y podemos ejecutar comandos de aws por ahí también

**Perfiles (named profiles)**:

- Con `aws configure --profile segundo-perfil` se agrega un perfil nuevo, para poder trabajar con **distintas cuentas**
  (o usuarios) desde el CLI.
- Cada perfil puede tener sus propias credenciales, región y formato de salida. Se guardan en `~/.aws/credentials` y
  `~/.aws/config`.
- Para usar un perfil se agrega `--profile segundo-perfil` al comando, o se define la variable de entorno
  `AWS_PROFILE`. Si no se indica ninguno, se usa el perfil `default`.

**MFA en el CLI (STS GetSessionToken)**:

Cuando una política exige MFA, las access keys solas no alcanzan. Se usa la API **STS `GetSessionToken`**, indicando el
**serial number** del dispositivo MFA (o su ARN, si es virtual) y el **código** que muestra en ese momento. A cambio
devuelve **credenciales temporales**: access key, secret key y un **session token**.

```bash
aws sts get-session-token \
  --serial-number arn:aws:iam::123456789012:mfa/mi-usuario \
  --token-code 123456
```

- Con esos tres valores se crea un **perfil nuevo** y se lo usa en los comandos que requieren MFA. Hay que cargar
  también el **session token**, no solo las dos keys.
- Duran **12 horas** por defecto y se puede cambiar entre 15 minutos y 36 horas con `--duration-seconds`.

**SDK**:

- Además del CLI, se puede usar un **SDK** en distintos lenguajes para hacer llamadas a la API de AWS desde el código
  de una aplicación (por ejemplo, para leer o escribir datos en un servicio).
- El SDK usa los mismos archivos de configuración y perfiles que el CLI.

### Estructura de Políticas IAM

Las políticas tienen la siguiente estructura JSON:

```json
{
  "Version": "2012-10-17",
  "Id": "PolicyId",
  "Statement": [
    {
      "Sid": "1",
      "Effect": "Allow|Deny",
      "Principal": "arn:aws:iam::123456789012:user/username",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::mybucket/*",
      "Condition": {
        "DateGreaterThan": {
          "aws:CurrentTime": "2023-01-01T00:00:00Z"
        }
      }
    }
  ]
}
```

**Campos principales**:

- **Version**: Versión del lenguaje de política (normalmente "2012-10-17"). Más que una fecha, define la sintaxis: la
  `2012-10-17` habilita *policy variables*; la antigua `2008-10-17` no las soporta. Para políticas nuevas usar siempre
  `2012-10-17`.
- **Id**: Un identificador opcional para la política
- **Statement**: Uno o más statements (requerido), son las descripciones de las políticas. Dentro del statement tenemos:
  - **Sid**: Cada statement tiene un ID identificador también
  - **Effect**: Lo que hace el statement - permitir o denegar (Allow o Deny)
  - **Principal**: A quién se aplica la política
  - **Action**: Lista de acciones que hace la política (ej: "s3:GetObject" para obtener un objeto de S3)
  - **Resource**: A qué servicios o recursos se aplica la política (ej: "arn:aws:s3:::mybucket/*")
  - **Condition**: Campo opcional que se puede agregar para condiciones específicas de cuándo comienza a aplicarse la
    política

> 📝 **Nota**: El orden de los elementos dentro de un statement no importa (ej: `Resource` puede ir antes que `Action`).
> AWS evalúa la política igual sin importar el orden.

### Mejores Prácticas

1. **Usar grupos** - Agrupa usuarios y asigna políticas a grupos en lugar de usuarios individuales para facilitar la
    gestión
2. **Principio de mínimos privilegios** - Otorga solo los permisos necesarios para realizar las tareas requeridas
3. **Políticas administradas de AWS** - Se pueden crear políticas personalizadas, pero es mejor utilizar políticas
    predefinidas de AWS cuando sea posible
4. **Rotación de credenciales** - Cambia regularmente las claves de acceso y contraseñas
5. **MFA obligatorio** - Habilita autenticación multifactor para cuentas con privilegios elevados
6. **Políticas de contraseñas** - Establece requisitos de complejidad y expiración para las contraseñas
7. **IAM Security Tools IAM Credentials Report (account-level)**: Reporta una lista con el status de los users
8. **IAM Security Tools IAM Access Advisor (user-level)**: Muestra los permisos de un usuario y cuando fue la ultima
    ves que accedió. Con esto podemos manejar el "Principio de mínimos privilegios"

## EC2 (Elastic Compute Cloud) Fundamentals

> 🔗 **Documentación oficial**: [Amazon EC2 User Guide](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/concepts.html)

### Conceptos Básicos EC2

Al lanzar una instancia EC2, tener en cuenta:

- **Sistema operativo**: Linux, Windows o macOS. Linux suele ser más económico y el más utilizado. Se define
  el SO base y el software pre-instalado.
- **Tipo de instancia (vCPU y RAM)**: Elige el tamaño según la carga. Familias general-purpose, compute-optimized y
  memory-optimized, entre otras.
- **Almacenamiento**:
  - **EBS**: Volúmenes persistentes conectados por red. Se mantienen al **detener** (stop) la instancia. Al
    **terminar** (terminate) dependen del flag "Delete on Termination": para el volumen raíz viene activado por defecto
    (se borra), para volúmenes adicionales viene desactivado (se conservan). Se usan para disco raíz y datos.
  - **Instance Store**: Almacenamiento efímero local al host. Alto rendimiento, pero los datos **sobreviven a un
    reboot (reinicio)** y se pierden al **detener (stop), hibernar o terminar** la instancia (a diferencia de EBS, que
    sí sobrevive al stop). Es un distractor típico del examen: reboot ≠ stop.
  - **EFS**: Sistema de archivos compartido por red para múltiples instancias **en varias AZ a la vez** (solo Linux),
    útil para escalado horizontal.
- **Red**:
  - **VPC y sub-red**: Elige sub-red pública (acceso a internet directo) o privada (sin IP pública).
  - **Direcciones IP**: IP privada obligatoria; IP pública opcional. Usa **Elastic IP** si necesitas una IP pública fija.
- **Seguridad y acceso**:
  - **Security Groups**: Firewall stateful a nivel de instancia/ENI. Define puertos/protocolos permitidos (por ejemplo
    SSH 22, HTTP 80, HTTPS 443). **Solo tienen reglas de "allow", nunca de "deny"**: todo lo que no está explícitamente
    permitido queda bloqueado. Diferencia clave con las **NACL** (Network ACL), que son stateless, actúan a nivel de
    subred y sí admiten reglas de allow y deny. (SG vs NACL es una comparación que cae seguido en el examen.)
  - **Par de claves (SSH/RDP)**: Requerido para acceso remoto seguro a la instancia.
  - **Rol de IAM**: Otorga permisos a la instancia para acceder a otros servicios de AWS sin usar credenciales embebidas.
- **Inicialización (User Data Script)**: Script de arranque para instalar paquetes y configurar la aplicación
  automáticamente al primer boot.

### Tipos de Instancias EC2

AWS ofrece distintas familias de instancias optimizadas para distintos casos de uso.

**Categorías principales**:

- **General Purpose**: equilibrio entre cómputo, memoria y red.
- **Compute Optimized**: optimizadas para cómputo intensivo.
- **Memory Optimized**: optimizadas para cargas que usan mucha RAM.
- **Storage Optimized**: optimizadas para acceso intensivo a disco.
- **Accelerated Computing**: con hardware acelerador (ej: GPUs).
- **HPC Optimized**: para computación de alto rendimiento (High Performance Computing).

### Convención de Nombres

Las instancias siguen el patrón `instanceClass + generation + tamaño`. Por ejemplo, en `m5.2xlarge`:

- **m**: instance class (familia).
- **5**: generation (AWS las va mejorando con el tiempo).
- **2xlarge**: tamaño de la instancia.

### Familias por Caso de Uso

- **General Purpose**: para web servers o levantar un repositorio de código (ej: GitLab).
  - Ejemplos: `mac`, `t4g`, `t3`, `t3a`, `t2`, `m6g`, `m5`, `m5a`, `m5n`, `m5zn`, `m4`, `a1`
- **Compute Optimized**: para cargas con mucha computación, como servidores dedicados de gaming o webs de alto
  rendimiento.
  - Ejemplos: `c6g`, `c6gn`, `c5`, `c5a`, `c5n`, `c4`
- **Memory Optimized**: mucha RAM, para aplicaciones en tiempo real o bases de datos de alto rendimiento.
  - Ejemplos: `r6g`, `r5`, `r5a`, `r5n`, `r4`, `x1e`, `x1`, `high memory`, `z1d`
- **Storage Optimized**: tareas de almacenamiento intensivo, que leen/escriben grandes volúmenes de datos o mantienen
  mucha caché.
  - Ejemplos: `i3`, `i3en`, `d2`, `d3`, `d3en`, `h1`

> 📝 **Nota**: Existen otras familias de instancias, pero estas son las más importantes para el examen.

### Comparación de Ejemplo

| Instance | vCPU | Mem (GiB) | Storage | Network Performance | EBS Bandwidth (Mbps) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| t2.micro | 1 | 1 | EBS-Only | Low to Moderate | - |
| t2.xlarge | 4 | 16 | EBS-Only | Moderate | - |
| c5d.4xlarge | 16 | 32 | 1 x 400 NVMe SSD | Up to 10 Gbps | 4,750 |
| r5.16xlarge | 64 | 512 | EBS Only | 20 Gbps | 13,600 |
| m5.8xlarge | 32 | 128 | EBS Only | 10 Gbps | 6,800 |

> 🔗 **Recurso**: Página no oficial para comparar instancias: <https://instances.vantage.sh/>

### Security Groups

Los **Security Groups** son la mejor forma de controlar quién tiene acceso a una instancia EC2. Actúan como un
firewall a nivel de instancia.

- Por defecto **todo está denegado**: solo pueden contener reglas de **allow** (nunca de deny).
- Pueden referenciar el origen por **IP** o por **otro Security Group**.

**Parámetros de una regla**:

- **Type**: tipo de tráfico (por ejemplo HTTP o SSH).
- **Protocol**: protocolo (por ejemplo TCP).
- **Port Range**: el puerto al que queremos dar acceso.
- **Source**: desde dónde se puede acceder a ese puerto (`0.0.0.0/0` es desde cualquier parte).
- **Description**: descripción corta de la regla.

Una instancia puede tener **varios Security Groups**. Por ejemplo, para deployar una app se puede dar acceso SSH a
una sola IP (la tuya) en un Security Group, y el acceso HTTPS abierto a todos en otro, para que cualquiera pueda ver
la app.

> 📝 **Nota**: En lugar de definir en un Security Group la IP de otra instancia, es mejor **referenciar el Security
> Group de la otra instancia**. Así las instancias pueden comunicarse entre sí sin depender de IPs fijas, incluso si
> estas cambian.

### Puertos Comunes

| Puerto | Protocolo | Uso |
| :--- | :--- | :--- |
| 21 | FTP | Transferencia de archivos (sin cifrar) |
| 22 | SSH | Ingreso seguro a la shell en instancias Linux |
| 22 | SFTP | Transferencia de archivos de forma segura (corre sobre SSH) |
| 80 | HTTP | Acceso a web sin certificado |
| 443 | HTTPS | Acceso a webs con certificado |
| 3389 | RDP | Acceso a escritorio remoto en instancias Windows |

> 📝 **Nota**: SFTP usa el puerto **22** porque viaja sobre SSH; no confundir con FTP (**21**), que es el protocolo
> clásico de transferencia sin cifrar.

### Formas de Conexión a una Instancia

- **SSH**: desde una terminal de Linux, macOS o Windows 10 en adelante.
- **PuTTY**: aplicación para conectarse desde cualquier versión de Windows.
- **EC2 Instance Connect**: conexión desde el navegador (web) a cualquier instancia, sin necesidad de clave local.

### EC2 Instance Metadata (IMDS)

El **Instance Metadata Service (IMDS)** permite que una instancia consulte **desde adentro** información sobre sí
misma, sin necesidad de un IAM Role ni de credenciales de AWS CLI para hacer la consulta. Solo es accesible desde la
propia instancia.

- **URL**: `http://169.254.169.254/latest/meta-data/` (una IP link-local, solo alcanzable desde la instancia).
- **Metadata**: información de la instancia (ID, tipo, AZ, IPs, etc.).
- **User data**: el script de inicialización con el que se lanzó la instancia. Está en una ruta aparte:
  `http://169.254.169.254/latest/user-data`.
- **IAM Role**: se puede obtener el **nombre del rol** y sus **credenciales temporales** en
  `iam/security-credentials/<nombre-del-rol>`, pero **no** la IAM Policy asociada. Así es como las aplicaciones de la
  instancia reciben credenciales sin tenerlas embebidas.

**IMDSv1 vs IMDSv2**:

| Versión | Cómo se consulta | Seguridad |
| :--- | :--- | :--- |
| **IMDSv1** | Un `GET` directo a la URL | Cualquier proceso (o una vulnerabilidad SSRF) puede leerlo |
| **IMDSv2** | Orientada a sesión: primero un `PUT` para obtener un **token**, y luego un `GET` enviando ese token en un header | **Más segura**: exige el token |

```bash
# IMDSv2: se pide un token (PUT) y se lo usa en el GET
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/profile
```

- El token define la duración de la sesión: mínimo **1 segundo**, máximo **6 horas**.
- En una instancia se puede permitir v1 y v2, o exigir **solo IMDSv2**. Amazon Linux 2023 trae IMDSv1 deshabilitado
  por defecto, y los tipos de instancia nuevos usan solo IMDSv2.

> 📝 **Nota del examen**: si una pregunta menciona la IP **169.254.169.254**, es el servicio de metadata. Y IMDSv2
> es la opción más segura porque requiere un **token**.

## EC2 Instance Storage

> 🔗 **Documentación oficial**: [Amazon EBS](https://docs.aws.amazon.com/ebs/latest/userguide/what-is-ebs.html) ·
> [Amazon EFS](https://docs.aws.amazon.com/efs/latest/ug/whatisefs.html)

### AMI (Amazon Machine Image)

Una **AMI** es una imagen con el sistema operativo y el software preinstalado que usamos como base para lanzar
instancias. Permite levantar una instancia con todas las herramientas que necesitamos ya configuradas.

Opciones de origen:

- **AMI públicas de Amazon**: imágenes base provistas por AWS.
- **AMI propias (custom)**: creadas y mantenidas por nosotros.
- **AMI del AWS Marketplace**: imágenes que terceros venden (y que también se pueden comprar).

**Cómo crear una AMI propia**: se lanza una instancia, se configura como queremos (paquetes, ajustes, etc.) y luego
se crea la AMI a partir de esa instancia para reutilizarla al lanzar otras.

### EBS (Elastic Block Store) Volumes

Un **EBS Volume** es un disco de red que se conecta a una instancia para guardar información que **persiste aunque la
instancia se termine** (según el flag "Delete on Termination"). Es un concepto parecido a los volúmenes de Docker.

- Se conectan a través de la **red** (no son discos físicos locales).
- Una instancia puede tener **varios EBS Volumes** conectados, pero siempre **dentro de su misma Availability Zone**.
- Para mover un EBS Volume de una AZ a otra hay que hacer un **snapshot** y restaurarlo en la AZ destino.
- El **snapshot** también sirve como **backup** del volumen. Se puede **archivar** para reducir costos (no está en uso)
  y restaurar cuando se necesite.

> 📝 **Nota**: El EBS Volume está atado a una sola AZ. El puente entre AZs (o entre regiones) siempre es el snapshot.

### Tipos de EBS Volumes

Se diferencian por tamaño, **throughput** (rendimiento) e **IOPS** (operaciones de I/O por segundo).

| Tipo | Tecnología | Caso de uso | IOPS máx. |
| :--- | :--- | :--- | :--- |
| **gp2 / gp3** | SSD | General purpose (disco raíz, apps) | hasta 16.000 |
| **io1 / io2** | SSD | Highest-performance (bases de datos críticas) | hasta 64.000 (io2 Block Express hasta 256.000) |
| **st1** | HDD | Bajo costo, acceso frecuente (throughput alto) | - |
| **sc1** | HDD | Costo más bajo, acceso poco frecuente (cold) | - |

> 📝 **Nota**: El tope de 64.000 IOPS en io1/io2 se garantiza solo en instancias basadas en el sistema **Nitro**; en
> otras familias el máximo es 32.000. Los volúmenes HDD (st1/sc1) **no** sirven como disco de arranque (boot).

**EBS Multi-Attach**: solo los volúmenes **io1 / io2** se pueden conectar a varias instancias a la vez (hasta **16
instancias**, todas dentro de la **misma Availability Zone**).

### EC2 Instance Store

Se comporta como un **disco físico** local al host, con **mucho más rendimiento** que un EBS Volume, pero es
**efímero**: lo que se guarda se pierde al terminar la instancia. Se usa para **caché** o **contenido temporal**.

### EFS (Elastic File System)

Es un **sistema de archivos por red** que se puede montar en **múltiples instancias en varias AZ a la vez**, y se
conecta controlando el acceso con **Security Groups**. Se paga por uso (tiende a ser más caro que EBS) y se usa para
**compartir datos entre varias EC2**, por ejemplo para servir el mismo WordPress desde todas las instancias.

- Compatible **solo con Linux** (usa el protocolo NFS).
- Usa **KMS** para encriptar los archivos.
- **No** hay que definir una capacidad: escala automáticamente.

**Performance mode** (se define al crear el file system):

- **General Purpose**: el recomendado para la mayoría de los casos (web servers, CMS). Menor latencia por operación.
- **Max I/O**: para cargas muy paralelas y pesadas (big data, procesamiento de video). Mayor latencia por operación.

**Throughput mode** (eje separado del performance mode):

- **Bursting** (por defecto): el rendimiento escala con la cantidad de datos almacenados.
- **Provisioned**: definimos nosotros un rendimiento fijo, independiente del tamaño.
- **Elastic**: escala automáticamente según la demanda.

**Storage tiers** (permiten ahorrar hasta ~90% en costos de almacenamiento):

- **Standard**: para archivos de acceso frecuente.
- **Infrequent Access (IA)**: almacenamiento más barato, pero con costo al recuperar archivos.
- **Archive**: para archivos que se acceden pocas veces al año; alrededor de 50% más barato que IA.

Se pueden definir **lifecycle policies** para mover archivos entre tiers automáticamente según su frecuencia de uso.

> 📝 **Nota del examen**: no confundir los dos ejes de configuración de EFS. **Performance mode** (General Purpose /
> Max I/O) es sobre latencia; **Throughput mode** (Bursting / Provisioned / Elastic) es sobre rendimiento. Son
> independientes entre sí.

## Scalability vs Availability

La **escalabilidad** es la capacidad de un sistema de adaptarse a una mayor carga; la **disponibilidad** es la
capacidad de seguir funcionando aunque falle una parte de la infraestructura. Están relacionadas pero son conceptos
distintos.

### Escalabilidad (Scalability)

**Vertical (scale up / scale down)**:

- Pasar a un servidor más grande (o más chico), por ejemplo subir de `t2.micro` a `t2.large`.
- Es la forma más sencilla de escalar cuando el ajuste de carga no es muy grande.
- Tiene un límite de hardware. Es típica en bases de datos no distribuidas (por ejemplo RDS).

**Horizontal (scale out / scale in)**:

- Tener **varias instancias** que ofrecen la misma app; los pedidos se distribuyen entre ellas.
- Más costoso, pero se pueden agregar tantas instancias como se necesiten, ideal para apps con muchísimos usuarios.
- Es la base de los **Auto Scaling Groups (ASG)** combinados con un **Load Balancer**.

### Disponibilidad (Availability)

Es poder seguir accediendo a la app aunque una instancia (o una AZ entera) se caiga. Normalmente se logra corriendo
la app en **al menos 2 Availability Zones**. Dos enfoques:

- **Pasivo (activo-pasivo)**: una instancia en espera (standby) que se activa cuando la principal falla.
- **Activo (asociado a la escalabilidad horizontal)**: varias instancias en distintas AZ trabajando en conjunto; si
  una se cae, las otras siguen recibiendo los pedidos.

> 📝 **Nota del examen**: escalabilidad ≠ disponibilidad. La escalabilidad responde a "¿cuánta carga aguanto?"; la
> disponibilidad responde a "¿sigo online si algo falla?". En AWS la alta disponibilidad casi siempre implica
> **multi-AZ**.

## Elastic Load Balancing (ELB)

> 🔗 **Documentación oficial**: [Elastic Load Balancing User Guide](https://docs.aws.amazon.com/elasticloadbalancing/latest/userguide/what-is-load-balancing.html)

El **ELB** es un servidor administrado que redirige el tráfico entre varias instancias o servicios. Usos principales:

- Distribuir la carga de los usuarios entre múltiples instancias.
- Exponer un **único punto de entrada** (DNS) para la aplicación.
- Redirigir automáticamente el tráfico fuera de las instancias caídas.
- Hacer **health checks** periódicos sobre las instancias.
- Terminar **SSL/TLS** (proveer HTTPS a las webs).
- Aplicar **stickiness** con cookies (ver más abajo).
- Mantener **alta disponibilidad** entre distintas AZ.
- Separar el tráfico público del privado.

El ELB chequea un endpoint de salud (por ejemplo `/health`) para saber si una instancia está activa y decidir si le
envía tráfico o la saca de rotación.

### Stickiness (Sticky Sessions)

**Stickiness** (o *session affinity*) es la capacidad de "pegar" a un mismo usuario siempre a la **misma instancia**
durante su sesión. El load balancer genera una **cookie** y, mientras esa cookie siga vigente, todas las requests de
ese usuario van a la misma instancia en lugar de repartirse.

- **Para qué sirve**: cuando la instancia guarda **estado de sesión en memoria** (login, carrito de compras, datos
  temporales). Si el usuario cayera en otra instancia, perdería esa sesión.
- **Contra**: puede desbalancear la carga, porque los usuarios quedan atados a instancias puntuales.
- En **ALB** las cookies pueden ser **duration-based** (generadas por el LB) o **application-based** (basadas en una
  cookie de la app). Se habilita **a nivel de target group**.

> 📝 **Nota**: la mejor práctica moderna es hacer las instancias **stateless** (guardar la sesión en un store externo
> como ElastiCache o DynamoDB) y así evitar depender de stickiness.

### Tipos de Load Balancer

| Tipo | Año | Capa (OSI) | Protocolos | Estado |
| :--- | :--- | :--- | :--- | :--- |
| **Classic Load Balancer (CLB)** | 2009 | 4 y 7 | HTTP, HTTPS, TCP, SSL (TCP seguro) | Deprecado (2022) |
| **Application Load Balancer (ALB)** | 2016 | 7 | HTTP, HTTPS, WebSocket, HTTP/2 | Vigente |
| **Network Load Balancer (NLB)** | 2017 | 4 | TCP, TLS (TCP seguro), UDP | Vigente |
| **Gateway Load Balancer (GWLB)** | 2020 | 3 | IP (protocolo GENEVE) | Vigente |

Es recomendable usar los load balancers nuevos (ALB/NLB/GWLB). Se pueden configurar como **internal** (redes privadas)
o **internet-facing / external** (redes públicas).

> 📝 **Qué son las "capas" (layers)**: se refiere al modelo **OSI**. **Layer 7** es la capa de aplicación (entiende
> HTTP: paths, headers, cookies). **Layer 4** es la capa de transporte (solo ve TCP/UDP, puertos e IPs, no el
> contenido HTTP). **Layer 3** es la capa de red (trabaja con paquetes IP puros). Regla rápida: **ALB = 7, NLB = 4,
> GWLB = 3**.
>
> 📝 **Patrón de seguridad**: para una app pública, el Security Group del load balancer permite el ingreso desde
> cualquier lado (`0.0.0.0/0`), y el Security Group de las instancias solo permite tráfico **proveniente del Security
> Group del load balancer**. Así nadie llega directo a las instancias, solo a través del LB.

### ALB (Application Load Balancer)

Opera en **layer 7 (HTTP/HTTPS)**. Sirve para acceder a múltiples aplicaciones en la misma instancia, o a múltiples
instancias con la misma aplicación. Soporta redirección de HTTP a HTTPS.

- **Routing avanzado** hacia distintos **target groups** según el **path**, el **hostname**, la **query string** o
  los **headers** de la request. Muy usado para **microservicios**.
- **Target groups posibles**: instancias EC2, **ECS tasks**, **Lambda functions**, direcciones IP (deben ser
  privadas). Puede haber varios target groups, y el health check se hace **a nivel de target group**.

**Headers con los datos del cliente**: como el backend solo ve la conexión que viene del ALB (no la del usuario
original), el ALB agrega la información real del cliente en tres headers HTTP:

- **`X-Forwarded-For`**: la **IP** del cliente original.
- **`X-Forwarded-Proto`**: el **protocolo** usado por el cliente (HTTP o HTTPS).
- **`X-Forwarded-Port`**: el **puerto** usado por el cliente.

### NLB (Network Load Balancer)

Opera en **layer 4 (TCP/UDP)**. Ofrece **alto rendimiento con latencia ultra baja**. Tiene una **IP estática por
Availability Zone** y soporta asignarle una **Elastic IP**.

- Se puede tener una app HTTP en la instancia y exponerla por el NLB a través de TCP.
- **Target groups posibles**: instancias EC2, direcciones IP privadas y un **Application Load Balancer** (este último
  patrón sirve para combinar la IP estática del NLB con el routing HTTP del ALB).
- El health check del NLB soporta los protocolos **TCP, HTTP y HTTPS**.

### GWLB (Gateway Load Balancer)

Opera en **layer 3 (paquetes IP)**. Se usa para **inspeccionar el tráfico** antes de que llegue a la aplicación: el
usuario se conecta al GWLB, este reenvía los paquetes a una flota de **appliances de terceros** (firewalls,
sistemas de intrusion detection/prevention, análisis de tráfico, etc.) y, si el tráfico está limpio, lo deja llegar a
la app.

Combina dos funciones en uno:

- **Transparent network gateway**: un único punto de entrada y salida para todo el tráfico.
- **Load balancer**: distribuye el tráfico entre los appliances y los escala según la demanda.

- **Target groups posibles**: instancias EC2 y direcciones IP privadas.

> 📝 **Nota del examen**: si una pregunta menciona el protocolo **GENEVE** o el puerto **6081**, está hablando del
> **Gateway Load Balancer**. Es su firma inconfundible.

### Combinar Load Balancers

Los load balancers se pueden **encadenar**, no porque hagan lo mismo en paralelo, sino porque cada uno aporta algo en
una capa distinta. No conviene apilarlos sin razón (suma latencia y costo); solo cuando cada uno resuelve un problema
que los otros no pueden.

- **NLB → ALB** (el combo más frecuente): el ALB se registra como **target group del NLB**. El NLB aporta la **IP
  estática / Elastic IP** (que el ALB no tiene) y el ALB aporta el **routing HTTP** (path, host, headers).
  Flujo: `Usuario → NLB (IP fija) → ALB (routing L7) → instancias`.
- **GWLB → ALB/NLB**: el GWLB se mete **antes** para inspeccionar el tráfico con appliances de seguridad
  (firewall/IDS/IPS) y luego lo deja seguir hacia el ALB/NLB que balancea la app.
  Flujo: `Usuario → appliances (GWLB) → ALB/NLB → instancias`.

> 📝 **Nota del examen**: si el escenario pide **IP estática y a la vez routing por path/host**, la respuesta es un
> **NLB con un ALB como target**. Es el patrón de combinación que más cae.

### Cross-Zone Load Balancing

Permite que cada nodo del load balancer (hay uno por AZ) distribuya la carga entre las instancias de **todas las AZ**,
no solo las de su propia zona.

- **Habilitado**: con 10 instancias en una AZ y 2 en otra, el tráfico se reparte parejo entre las **12** instancias.
- **Deshabilitado**: cada nodo reparte solo entre las instancias de su AZ (el de la primera zona entre 10, el de la
  otra entre 2), lo que puede desbalancear la carga.

Comportamiento por defecto y costo:

- **ALB**: habilitado por defecto y **sin cargo extra**.
- **NLB** y **GWLB**: deshabilitado por defecto; si se habilita, **genera cargos** por transferencia entre AZ.

### Certificados SSL/TLS en ELB

Un certificado permite cifrar las conexiones entre el cliente y el ELB (HTTPS). El ELB **termina** el TLS: el usuario
habla **con cifrado** (HTTPS) con el ELB, y el ELB puede hablar **sin cifrado** (HTTP) con la instancia por detrás.

- Los certificados se pueden gestionar con **ACM (AWS Certificate Manager)** o subir los propios.
- Tienen **fecha de expiración**, hay que renovarlos (ACM puede renovarlos automáticamente).
- Para servir **varias aplicaciones con distinto dominio** detrás del mismo load balancer se cargan **múltiples
  certificados** usando **SNI (Server Name Indication)**, que elige el certificado correcto según el dominio pedido.
  Soportado por **ALB y NLB** (el viejo CLB solo admite un certificado).

> 📝 **SSL vs TLS**: no son cosas distintas por tipo de tráfico. **TLS (Transport Layer Security)** es la versión
> moderna y segura que **reemplazó a SSL (Secure Sockets Layer)**, hoy obsoleto. Se siguen llamando "certificados SSL"
> por costumbre, pero lo que se usa en la práctica es TLS.

### Connection Draining (Deregistration Delay)

Cuando una instancia **se desregistra o queda unhealthy**, el ELB le da un período para **terminar las requests en
curso** antes de cortar la conexión, así no se interrumpe a los usuarios que estaban a mitad de una operación.

- Valor por defecto: **300 segundos**. Rango configurable: **1 a 3.600 segundos** (0 lo desactiva).
- Conviene ajustarlo al tiempo típico de las requests: más alto si hay procesos largos, más bajo si son cortos.

> 📝 **Nota**: "Connection Draining" es el nombre en el **CLB**; en **ALB y NLB** el mismo concepto se llama
> **deregistration delay**. Son lo mismo para el examen.

## Auto Scaling Group (ASG)

> 🔗 **Documentación oficial**: [Amazon EC2 Auto Scaling User Guide](https://docs.aws.amazon.com/autoscaling/ec2/userguide/what-is-amazon-ec2-auto-scaling.html)

Una aplicación tiene más o menos usuarios según el momento. El **ASG** permite **escalar OUT o IN** las instancias EC2
automáticamente, para tener más o menos instancias con la misma app. Se configuran tres valores:

- **Minimum capacity**: mínimo de instancias corriendo.
- **Desired capacity**: cantidad que el ASG intenta mantener.
- **Maximum capacity**: tope de instancias.

Al **asociar un ASG con un ELB**, las N instancias del ASG se registran automáticamente en el ELB. La ventaja de
usarlos juntos: si el ELB detecta (vía health check) que una instancia está caída, el ASG la **termina y crea otra**
en su lugar.

- El disparador de escalado (out/in) suele ser una **alarma de CloudWatch**.
- El ASG **es gratis**: solo se paga por las instancias y servicios asociados.

**Launch Template** (necesario para crear el ASG), debe incluir:

- AMI + instance type
- EC2 User Data
- EBS Volumes
- Security Groups
- SSH Key Pair
- IAM Roles para las instancias EC2
- Network + Subnets
- Load Balancer Information

Además del template se define: **min size, max size, desired/initial capacity** y las **scaling policies**.

### ASG - Scaling Policies

**Dynamic Scaling**:

- **Target Tracking**: se fija un valor objetivo que el ASG intenta mantener (por ejemplo, CPU promedio al 40%) y
  escala out/in para acercarse a ese valor. Es la más simple de configurar.
- **Simple / Step Scaling**: se dispara con **alarmas de CloudWatch** para escalar out o in (step permite escalones
  según cuánto se supera el umbral).

**Scheduled Scaling**: anticipa el escalado según un **patrón horario conocido** (por ejemplo, menos instancias de
noche si hay menos usuarios).

**Predictive Scaling**: usa machine learning para **detectar patrones** y escalar de forma anticipada en cargas
cíclicas (por ejemplo, más usuarios los fines de semana).

**Métricas típicas para escalar**:

- **CPUUtilization**: según el uso de CPU de las instancias.
- **RequestCountPerTarget**: para mantener estable el número de requests por instancia.
- **Average Network In/Out**: para apps que suben o descargan muchos archivos.
- Cualquier **métrica custom** de CloudWatch.

> 📝 **Cooldown period**: por defecto **300 segundos** durante los cuales el ASG no lanza ni termina instancias (para
> estabilizarse). Conviene usar una **AMI** con todo preinstalado para que las instancias arranquen rápido y así
> reducir el impacto del cooldown.

### ASG - Instance Refresh

Cuando queremos actualizar todo el ASG con un **nuevo launch template** y recrear las instancias, se activa el
**Instance Refresh**: mantiene un mínimo de instancias trabajando (según un porcentaje de salud configurable) y va
reemplazando el resto de a poco, sin cortar el servicio.

## Amazon RDS (Relational Database Service)

> 🔗 **Documentación oficial**: [Amazon RDS User Guide](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Welcome.html)

Es el servicio administrado para aprovisionar bases de datos **relacionales** (que usan SQL como lenguaje). Soporta
varios motores (engines): **PostgreSQL, MySQL, MariaDB, Oracle, Microsoft SQL Server, IBM DB2** y **Aurora** (base de
datos propietaria de AWS, compatible con MySQL y PostgreSQL).

### Por qué usar RDS en lugar de instalar la DB en una EC2 propia

- Aprovisionamiento automático y **parches de SO** aplicados automáticamente.
- **Backups** automáticos y restore a un punto en el tiempo (point-in-time recovery).
- **Dashboard de monitoreo** incluido.
- **Read Replicas** para repartir las lecturas y mejorar la performance.
- **Multi-AZ** para disaster recovery (alta disponibilidad con failover automático).
- **Ventanas de mantenimiento** para las actualizaciones.
- **Escalado vertical** (cambiar el tamaño de la instancia) y de **storage** (crecer el disco).
- Almacenamiento **respaldado por EBS** (gp2/gp3).
- **No se puede** ingresar por SSH a las instancias de RDS (es un servicio administrado).

> 📝 **"Storage backed by EBS"**: el disco de una instancia RDS vive sobre volúmenes **EBS** (los mismos discos de red
> de EC2). Por eso RDS usa tipos como gp2/gp3 y puede crecer el almacenamiento.
>
> 📝 **Ojo con "escalado horizontal"**: RDS **no** escala horizontalmente solo (no es un ASG). El escalado vertical y
> el de storage sí los gestiona RDS. Para repartir lecturas se usan **Read Replicas** (hasta 15), que se agregan de
> forma manual. La escritura siempre va a la instancia principal.

### RDS Storage Auto Scaling

Permite que el almacenamiento de la DB **crezca automáticamente** cuando se está quedando sin espacio, para evitar
tener que escalarlo a mano. Por ejemplo, si creamos una RDS con 20 GB y se llena, el auto scaling agranda el disco
solo.

- Hay que definir un **Maximum Storage Threshold**: el tope hasta el que puede crecer.
- Se dispara automáticamente cuando se cumplen **las tres condiciones**:
  1. El espacio libre es **menor al 10%** del almacenamiento asignado.
  2. La condición de poco espacio dura **al menos 5 minutos**.
  3. Pasaron **al menos 6 horas** desde la última modificación de storage.
- Útil para aplicaciones con uso **poco predecible**. Soporta todos los engines de RDS.

### RDS Read Replicas vs Multi-AZ

**Read Replicas** (replicas de solo lectura, para mejorar la performance):

- Son copias de la DB principal que **solo sirven para leer** (las escrituras van siempre a la principal).
- Se pueden crear hasta **15 replicas**, en la misma AZ, **cross-AZ** o **cross-region**.
- Una replica puede **promoverse a DB principal**, pero al hacerlo deja de estar ligada a la DB original.
- La aplicación tiene que apuntar sus consultas de lectura a las replicas (su propio connection string).
- **Caso típico**: tenés una RDS funcionando y querés agregar un dashboard de reportes. Para no cargar la DB
  principal, creás una replica y hacés las consultas de solo lectura ahí.

> 📝 **Costos de red en Read Replicas**: cuando las replicas están en la **misma AZ** no hay costo de transferencia;
> si están en **otra AZ** (cross-AZ), sí se cobra la red. Es un comportamiento típico de AWS para tráfico cross-AZ.

**Multi-AZ** (para disaster recovery / alta disponibilidad):

- Es una replica **standby sincrónica** que se convierte en principal automáticamente (failover) si hay un problema:
  se pierde la conexión, falla el storage, etc.
- Una Read Replica también se puede configurar como Multi-AZ para DR.
- **Pasar de Single-AZ a Multi-AZ**: se hace con un clic en "Modify" sobre la instancia; **sin downtime**.
  Internamente toma un **snapshot EBS**, lo restaura en otra AZ, sincroniza las dos DB y ya queda en Multi-AZ.

## Amazon Aurora

> 🔗 **Documentación oficial**: [Amazon Aurora User Guide](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/CHAP_AuroraOverview.html)

Aurora es una tecnología **propietaria de AWS** (no open source). Soporta los mismos drivers de conexión que **MySQL
y PostgreSQL**. Está optimizada para la nube:

- Hasta **5x** mejor performance que MySQL y **3x** que PostgreSQL en RDS, aunque cuesta ~20% más.
- El storage crece automáticamente de **10 GB hasta 256 TiB** (en incrementos de 10 GB).
- Hasta **15 read replicas** (más rápidas que las de MySQL) y failover casi instantáneo por ser cloud-native.

### Almacenamiento de Aurora (6 copias en 3 AZ)

- Mantiene **6 copias de los datos distribuidas en 3 Availability Zones**.
- Necesita **4 de 6** copias disponibles para **escribir**, y **3 de 6** para **leer** (modelo de quórum).
- **Self-healing**: si un bloque se corrompe, se repara automáticamente usando las otras copias.
- El almacenamiento no está en un solo volumen: se expande a través de **múltiples volúmenes**.

Una de las instancias actúa como **master (writer)**; si se cae, otra la reemplaza en **menos de 30 segundos**.
Además del master se pueden tener hasta **15 read replicas** (con cross-region replication), y cualquiera puede
promoverse a master.

### Endpoints de Aurora

A diferencia de RDS (donde manejás una lista de connection strings para las replicas), Aurora expone dos endpoints:

- **Writer endpoint**: se conecta siempre al **master** para escribir.
- **Reader endpoint**: tiene un **Load Balancer interno** que reparte las lecturas entre las replicas.

### RDS y Aurora - Security

- **Encriptación en reposo** con **AWS KMS**: se define **al lanzar** la instancia. Si el master no está encriptado,
  las replicas tampoco pueden estarlo. Para encriptar una DB ya creada sin cifrado: hacés un **snapshot**, y al
  restaurarlo lo definís como encriptado.
- **TLS** (encriptación en tránsito) listo por defecto usando el AWS TLS root certificate.
- Autenticación con **IAM** (en lugar de usuario/password) o con usuario/password tradicional.
- Control de acceso a nivel de red con **Security Groups**.
- **No hay acceso SSH** a las instancias (excepto en RDS Custom).
- Los **audit logs** se pueden habilitar y enviar a **CloudWatch Logs**; para retención larga se exportan a otros
  servicios.

### RDS Proxy

Un proxy administrado que centraliza las conexiones a la DB. Beneficios:

- **Connection pooling**: agrupa y reutiliza conexiones, reduciendo el overhead de CPU/RAM en la DB.
- Reduce el tiempo de **failover** de RDS y Aurora hasta en un **66%** (evita los retrasos de propagación de DNS).
- Es **serverless**, autoescalable y **Multi-AZ** (alta disponibilidad).
- Refuerza la autenticación **IAM** y guarda las credenciales en **AWS Secrets Manager**.
- **No es accesible desde internet**, solo desde dentro de la VPC / servicios de AWS.

> 📝 **Caso de uso estrella**: muchas funciones **Lambda** conectándose a la misma DB. Lambda abre muchas conexiones
> cortas y frecuentes; RDS Proxy las agrupa y evita saturar la base. Es pregunta frecuente en el examen.

## Amazon ElastiCache

> 🔗 **Documentación oficial**: [Amazon ElastiCache: Redis vs Memcached](https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/SelectEngine.html)

Es un servicio administrado de almacenamiento **en memoria (RAM)** de tipo **clave-valor (NoSQL)**, con dos motores:
**Redis** o **Memcached**. Es un servicio **aparte de RDS** (no es la RAM del RDS). Se usa principalmente como
**caché** para acelerar aplicaciones web y **reducir la carga sobre la base de datos** en cargas intensivas. AWS se
encarga del mantenimiento del sistema operativo.

Casos de uso típicos:

- **Cache de base de datos**: cuando la app necesita datos, consulta primero a ElastiCache; si no están ahí (cache
  miss), va al RDS y guarda el resultado en la caché para la próxima vez.
- **Session store**: guardar la sesión de un usuario para recuperarla rápido mientras navega, lo que ayuda a mantener
  la aplicación **stateless** (las instancias no dependen de guardar la sesión en memoria local).

### Redis vs Memcached

| Característica | Redis | Memcached |
| :--- | :--- | :--- |
| Alta disponibilidad | **Multi-AZ** con auto failover | No (nodos independientes) |
| Read Replicas | Sí (escalar lecturas + HA) | No |
| Persistencia de datos | Sí (AOF persistence) | No (datos efímeros) |
| Backup & restore | Sí | No |
| Estructuras de datos | Sets, Sorted Sets, listas, etc. | Solo clave-valor simple |
| Arquitectura | Principalmente single-threaded | **Multi-threaded** (varios cores) |
| Partición (sharding) | Sí | Sí (nodos particionados) |

Regla rápida: **Redis** cuando necesitás durabilidad, alta disponibilidad y features avanzadas; **Memcached** para una
caché simple, pura clave-valor, que escale horizontalmente con muchos nodos.

> 📝 **Conceptos que aparecen acá**:
>
> - **AOF (Append Only File)**: un log en disco donde Redis registra cada escritura, para poder **recuperar los datos**
>   si el nodo se reinicia. Es lo que le da durabilidad (Memcached no lo tiene).
> - **Sets / Sorted Sets**: estructuras de datos que Redis maneja nativamente. Un **Set** es una colección sin
>   duplicados; un **Sorted Set** ordena los elementos por un puntaje (ideal para rankings/leaderboards).
> - **Multi-threaded**: Memcached usa **varios hilos/núcleos** en paralelo, por lo que aprovecha mejor una máquina con
>   muchos cores. Redis es principalmente de un solo hilo.

### Estrategias de Caché

**Lazy Loading** (también llamada *Cache-Aside* o *Lazy Population*): se cachea al **leer**. La app lee primero el
cache; si no hay datos (cache miss), lee de la DB, los trae y recién ahí los guarda en el cache.

- **Pros**: solo se cachea lo que realmente se lee, no se llena el cache con datos que no se usan.
- **Contras**: un cache miss implica tres pasos (cache → DB → cache), lo que agrega algo de latencia en esa request.
  Además, los datos pueden quedar **obsoletos (stale)**, porque el cache no se actualiza cuando cambia la DB.

**Write-Through**: se cachea al **escribir**. Cada vez que se escribe en la DB, también se escribe en el cache. Se usa
cuando el dato no cambia muy seguido (por ejemplo, un post de red social).

- **Pros**: los datos en cache siempre están frescos, no hay latencia extra en las lecturas.
- **Contras**: agrega latencia en las escrituras, y puede **cachear datos que quizás nunca se lean** (desperdicia
  memoria).

**Cache Evictions y TTL**: un elemento sale del cache por tres motivos:

- Se **elimina explícitamente** (por ejemplo, al borrar el item en la DB).
- Es **evicted** (expulsado) porque la memoria está llena y es el menos usado recientemente.
- Expira su **TTL (Time To Live)**: un tiempo de vida que se le asigna a cada elemento, tras el cual se invalida solo.

> 📝 **Nota del examen**: Lazy Loading y Write-Through suelen **combinarse**, y el **TTL** es la forma más común de
> mitigar los datos obsoletos del Lazy Loading. Si la pregunta habla de "datos stale en el cache", pensá en TTL.

## Amazon Route 53

> 🔗 **Documentación oficial**: [Amazon Route 53 Developer Guide](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/Welcome.html)

Es el servicio **DNS administrado** de AWS. Permite administrar los registros DNS, **registrar nuevos dominios** y
hacer **health checks** de los servicios. Es el **único servicio de AWS con un SLA de 100% de disponibilidad**.

> 📝 **Nota**: el 100% aplica a responder las consultas DNS (data plane), no a la consola ni a la API de gestión.

### Conceptos DNS básicos

- **Domain Registrar**: empresa donde se registra un dominio (Route 53 lo es, pero también existen otras).
- **DNS Records**: registros que definen a dónde apunta cada nombre (A, AAAA, CNAME, NS, etc.).
- **Zone File**: archivo que contiene los DNS records de un dominio.
- **Name Server**: servidor que resuelve las consultas DNS.
- **TLD (Top Level Domain)**: la terminación del dominio, por ejemplo `.com` u `.org`.
- **FQDN (Fully Qualified Domain Name)**: nombre completo, por ejemplo `api.www.example.com.`

### Hosted Zones

Una **hosted zone** es el contenedor de records que define cómo se rutea el tráfico de un dominio y sus subdominios.

- **Pública**: responde consultas desde internet.
- **Privada**: responde consultas solo dentro de una o más **VPC**.
- Se cobra un costo mensual de $0.50 dolares por cada hosted zone.

> 📝 **Registrar vs servicio DNS**: Route 53 hace las dos cosas, pero se puede registrar el dominio en otro proveedor y
> usar Route 53 solo como DNS. Para eso se configuran, en el registrar, los **NS** que Route 53 asignó a la hosted zone.

### Records

Un record define cómo se rutea el tráfico a través de un dominio. Cada record tiene:

- **Domain / subdomain name**: por ejemplo `example.com` o `api.example.com`.
- **Record type**: por ejemplo `A` o `AAAA`.
- **Value**: el dato que devuelve el record, que depende del tipo. En un `A` es una IPv4 (ej: `12.34.56.78`), en un
  `AAAA` una IPv6 y en un `CNAME` otro hostname.
- **Routing policy**: cómo responde Route 53 a las consultas (ver más abajo).
- **TTL**: el tiempo que los resolvers DNS y los clientes **cachean** la respuesta.

Tipos de record soportados: `A`, `AAAA`, `CNAME`, `NS`, `CAA`, `MX`, `NAPTR`, `PTR`, `SOA`, `TXT`, `SPF`, `SRV`.

Los más importantes:

| Tipo | Qué hace |
| :--- | :--- |
| **A** | Mapea un hostname a una **IPv4** |
| **AAAA** | Mapea un hostname a una **IPv6** |
| **CNAME** | Mapea un hostname a **otro hostname**. El destino debe terminar resolviendo a un `A` o `AAAA` |
| **NS** | Lista los **name servers** autoritativos de la hosted zone (los que responden por ese dominio) |

> 📝 **Nota**: un CNAME **no se puede crear en el dominio raíz** (zone apex). Por ejemplo, no se puede para
> `example.com`, pero sí para `api.example.com`.

### CNAME vs Alias

El **Alias** es una extensión propia de Route 53 para apuntar un hostname a **recursos de AWS**.

| Característica | CNAME | Alias |
| :--- | :--- | :--- |
| Dominio raíz (`example.com`) | No | **Sí** |
| Subdominio (`api.example.com`) | Sí | Sí |
| Destino | Cualquier hostname | Recursos de AWS |
| Costo de las consultas | Se cobran | **Gratis** (hacia recursos de AWS) |
| Health check | No | **Nativo** (Evaluate Target Health) |

Destinos típicos de un Alias: **ELB**, **CloudFront**, **API Gateway**, **S3** (website), entre otros.

> 📝 **Nota del examen**: un Alias **no puede apuntar al DNS name de una instancia EC2**. Para EC2 se usa un record
> normal (A) más un health check. Y como un **load balancer tiene DNS name y no IP fija**, se lo expone con un
> **Alias** (ver sección de ELB).

### Routing Policies (resumen)

La routing policy define **cómo responde Route 53** a una consulta DNS.

| Policy | Qué hace | Cuándo usarla |
| :--- | :--- | :--- |
| **Simple** | Devuelve uno o varios valores; el cliente elige uno al azar | Un solo recurso. No admite health checks |
| **Weighted** | Reparte el tráfico según **pesos** que se asignan a cada record | Pruebas A/B, canary deployments |
| **Latency** | Envía al usuario a la **región con menor latencia** | Usuarios distribuidos en varias regiones |
| **Failover** | **Activo-pasivo**: usa el primario y pasa al secundario si falla | Disaster recovery. Requiere health check |
| **Geolocation** | Rutea según la **ubicación del usuario** (país, continente) | Localización, restricciones por región |
| **Geoproximity** | Rutea según la ubicación de usuarios y recursos, con un **bias** ajustable | Mover tráfico entre regiones |
| **IP-based** | Rutea según el **rango de IP (CIDR)** del cliente | Optimizar según la red de origen |
| **Multi-value** | Devuelve hasta **8 records saludables** al azar | Balanceo simple con health checks |

> 📝 **Nota del examen**: **Geolocation** decide por *dónde está el usuario*; **Latency** por *qué región responde
> más rápido*. No son lo mismo.

### Health Checks

Permiten que Route 53 **monitoree la salud de los recursos** y deje de enviar tráfico a los que fallan. Se usan junto
con las routing policies (sobre todo Failover) y con el Alias.

Tipos de health check:

- **Endpoint**: monitorea un endpoint (IP o dominio) por HTTP, HTTPS o TCP, cada 10 o 30 segundos, desde varias
  regiones.
- **Calculated**: combina el resultado de **varios health checks** en uno solo.
- **CloudWatch Alarm**: se basa en el estado de una **alarma de CloudWatch**.

> 📝 **Nota del examen**: los health checkers de Route 53 están **fuera de la VPC**, por lo que no pueden llegar a
> recursos privados. Para monitorear un recurso privado se usa un health check basado en una **alarma de CloudWatch**.

## Amazon VPC (Virtual Private Cloud)

> 🔗 **Documentación oficial**: [Amazon VPC User Guide](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html)

Una **VPC** es una red virtual privada y aislada dentro de AWS, donde se despliegan los recursos (EC2, RDS, etc.). Sirve,
por ejemplo, para aplicaciones internas de una empresa.

- Es un recurso **regional**: pertenece a una sola región. Se pueden tener **varias VPC por región** (hay una cuota
  ampliable), y si se trabaja en dos regiones, cada una necesita su propia VPC.
- Cada región trae una **default VPC** ya configurada para empezar a usar.
- Por defecto está aislada: solo tiene salida a internet si se le agrega un **Internet Gateway** y una ruta que lo use.

### Subnets

Las **subnets** son particiones dentro de una VPC.

- Cada subnet vive en **una sola Availability Zone** (no se extiende entre zonas). Para alta disponibilidad se crea
  una por AZ.
- **Subnet pública**: tiene una ruta hacia el Internet Gateway. Para recursos que necesitan acceso a internet, como
  un load balancer.
- **Subnet privada**: sin ruta directa a internet. Para aplicaciones internas y bases de datos, con más seguridad.
- **CIDR**: la VPC y cada subnet tienen un rango de IPs, por ejemplo `10.0.0.0/16`.
- **Route tables**: definen a dónde va el tráfico de cada subnet. Es lo que distingue una subnet pública de una
  privada.

### Conectividad a Internet

| Componente | Qué hace |
| :--- | :--- |
| **Internet Gateway (IGW)** | Se asocia a la VPC y permite que los recursos de las subnets públicas se conecten a internet (entrada y salida) |
| **NAT Gateway** | Vive en una **subnet pública** y permite que los recursos de las subnets **privadas** inicien conexiones hacia internet, sin que internet pueda iniciar una hacia ellos |

> 📝 **Caso típico**: una app en la subnet privada necesita un dato de la web (actualizaciones, una API externa). Sale
> por el **NAT Gateway** de la subnet pública, que a su vez usa el Internet Gateway. Así la red privada nunca queda
> expuesta a conexiones entrantes.

### Seguridad: NACL y Security Groups

La **NACL (Network ACL)** es un firewall que controla el tráfico que entra y sale de una **subnet**, y puede **permitir
o denegar** IPs. Se usa en conjunto con los Security Groups para reforzar la seguridad.

| Característica | Security Group | NACL |
| :--- | :--- | :--- |
| Nivel | Instancia (ENI) | Subnet |
| Estado | Stateful | **Stateless** |
| Tipo de reglas | Solo allow | Allow y deny |

### Arquitectura típica de 3 capas

1. **Capa web**: un **ELB** en subnets públicas, al que apunta **Route 53** (el DNS está delante, no cuenta como capa).
2. **Capa de aplicación**: instancias **EC2** en una **subnet privada**, a las que solo puede acceder el load balancer
   (el Security Group de las EC2 referencia al del load balancer).
3. **Capa de datos**: **RDS** o **ElastiCache** en otra subnet privada.

Otro stack común es **LAMP** (Linux, Apache, MySQL y PHP) sobre EC2.

## Amazon S3 (Simple Storage Service)

> 🔗 **Documentación oficial**: [Amazon S3 User Guide](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html)

Es uno de los servicios fundamentales de AWS: almacenamiento de **objetos** con escalabilidad prácticamente ilimitada
("infinite storage"). Usos típicos:

- Backup y almacenamiento.
- Disaster recovery.
- Archivado de datos.
- Hybrid cloud storage.
- Hosting de aplicaciones y de archivos multimedia.
- Big data.
- Software delivery.
- Sitios web estáticos.

### Buckets

Un **bucket** es el contenedor donde se almacenan los objetos (los archivos). Se crea **en una región**, pero por
defecto su nombre es **global y único** entre todas las cuentas y todas las regiones (dentro de una partición).

> 📝 **Account regional namespace**: desde 2026 se puede crear un bucket dentro de un namespace propio de la cuenta y
> la región, con el formato `{prefijo}-{account-id}-{region}-an`. Así el mismo prefijo se puede reutilizar en cada
> región (como buckets distintos) sin chocar con nombres de otras cuentas. No es un único bucket compartido entre
> regiones.

**Reglas para el nombre de un bucket**:

- Entre 3 y 63 caracteres.
- Solo minúsculas, números, puntos y guiones medios (no se permiten mayúsculas ni guiones bajos).
- Debe empezar y terminar con una letra o un número (**sí puede empezar con un número**).
- No puede tener dos puntos seguidos.
- No puede tener formato de dirección IP.
- No puede empezar con el prefijo `xn--`.
- No puede terminar con el sufijo `-s3alias`.

### Objects

Los **objetos** son los archivos que se guardan en el bucket. Cada uno se identifica por una **key**, que es la ruta
completa del objeto dentro del bucket. Por ejemplo, en `s3://my-bucket/my_folder1/myfile.txt` la key es
`my_folder1/myfile.txt`.

- **No existen los directorios**: aunque la consola los muestre, son solo keys con nombres largos separados por `/`.
- **Tamaño máximo**: hasta **50 TB** por objeto.
- **Multi-part upload**: una sola operación de subida admite como máximo **5 GB**, por lo que para objetos más
  grandes es **obligatorio** usar multi-part upload. Se recomienda ya desde los 100 MB.
- Un objeto también tiene **metadata** (lista de pares key/value), **tags** y un **version ID** (si hay versionado).
- **No se puede buscar** objetos por tags ni por metadata: S3 no ofrece esa consulta. El patrón clásico es guardar esos
  datos en una base como **DynamoDB** y consultarla ahí. También existe **S3 Metadata**, que expone la metadata como
  tablas consultables con Athena (solo en buckets de propósito general).

### S3 Security

El acceso a los buckets y objetos se controla con:

- **Políticas IAM** asociadas a usuarios, grupos o roles.
- **Bucket policies**: documentos JSON como las de IAM, pero adjuntos al propio bucket. Permiten o deniegan el acceso,
  dar acceso público al bucket o a sus objetos, y dar acceso **cross-account**.
- **ACLs** (Access Control Lists), a nivel de bucket o de objeto.
- **Encriptación** de los objetos mediante una clave de encriptación.

#### MFA Delete

Exige un segundo factor (**MFA**) para las operaciones más sensibles sobre un bucket.

- Solo funciona en buckets con **versionado** habilitado.
- Solo el **root** de la cuenta puede habilitarlo.
- Con MFA Delete activo, hace falta MFA para **borrar una versión de forma permanente** o para **cambiar el estado del
  versionado**.

#### Server Access Logs

Se pueden habilitar los **access logs** para guardar el detalle de cada request que recibe el bucket.

- Los logs se entregan en **otro bucket**, que debe estar en la **misma región y en la misma cuenta**.
- No conviene usar el mismo bucket como destino: genera un **loop infinito de logs** (cada log escrito genera un nuevo
  log). Es posible, pero no se recomienda.
- La entrega de logs no tiene costo, solo se paga el almacenamiento de los archivos.

#### Presigned URLs

Una **URL pre-firmada** da acceso temporal a un objeto privado: se genera con una **expiración** y se comparte con quien
no tiene credenciales de AWS.

- Sirve para **descargar** (GET) o **subir** (PUT) un objeto.
- Expiración máxima: **12 horas** si se genera desde la consola, hasta **7 días** desde el CLI o un SDK.
- Tiene los **permisos de quien la creó**: si esa persona no puede acceder al objeto, la URL tampoco.
- Si se firmó con **credenciales temporales** (por ejemplo, un rol), vence cuando vence ese token, aunque la expiración
  configurada sea mayor.

#### S3 Access Points

Un **access point** es un punto de entrada a un bucket con su **propia policy** y su **propio DNS name**. Permite
definir quién accede a qué parte de un bucket compartido sin crecer una única bucket policy.

- Por ejemplo, un access point cuya policy permite solo a un grupo definido acceder al prefijo `finance/` del bucket,
  para que no sea accesible a cualquier usuario.
- Trabaja **junto con la bucket policy**, y sus restricciones aplican solo a los requests hechos **a través de ese
  access point**.
- Se puede restringir para que acepte requests solo desde una **VPC**.

**S3 Object Lambda Access Point**: pone una **Lambda entre la aplicación y S3 cuando se lee un objeto**, y transforma
el dato antes de devolverlo. Por ejemplo, redactar información personal (PII), convertir el formato o filtrar campos,
sin modificar el objeto original. Solo procesa requests GET, LIST y HEAD.

> 📝 **Notas**:
>
> - Object Lambda **no envía** datos a otras aplicaciones al crearse un objeto. Para reaccionar a un evento de S3 se
>   usan las **S3 Event Notifications**.
> - Desde el 7 de noviembre de 2025, S3 Object Lambda está disponible **solo para clientes que ya lo usaban** y
>   algunos partners de AWS. El curso puede seguir enseñándolo.

### S3 Replication (CRR y SRR)

Copia los objetos de un bucket a otro de forma automática. Hay dos variantes:

- **CRR (Cross-Region Replication)**: entre regiones distintas, por ejemplo para bajar la latencia de acceso o por
  compliance.
- **SRR (Same-Region Replication)**: dentro de la misma región, por ejemplo para replicar datos a un entorno de test.

Qué hay que tener en cuenta:

- Hay que habilitar el **versionado** y configurar bien los **permisos**.
- La copia es **asincrónica**.
- Se puede replicar **cross-account**.
- Al habilitarla, solo se replican los objetos **nuevos**. Para los que ya existían se usa **S3 Batch Replication**.
- Los **delete markers** se pueden replicar, pero las eliminaciones con **version ID** no se replican, para evitar
  borrados maliciosos.
- La replicación **no es transitiva**: si se replica del bucket 1 al 2 y del 2 al 3, los objetos no llegan del 1 al 3.

### S3 Storage Classes

| Clase | Disponibilidad | Duración mínima | Tiempo de acceso | Uso típico |
| :--- | :--- | :--- | :--- | :--- |
| **Standard - General Purpose** | 99,99% | - | Milisegundos | Acceso frecuente: big data, mobile, gaming |
| **Standard - Infrequent Access (IA)** | 99,9% | 30 días | Milisegundos | Backups, disaster recovery |
| **One Zone - IA** | 99,5% | 30 días | Milisegundos | Copias secundarias de datos on-premise o datos recreables |
| **Glacier Instant Retrieval** | - | 90 días | Milisegundos | Datos que se acceden una vez por trimestre |
| **Glacier Flexible Retrieval** | - | 90 días | Expedited 1-5 min, Standard 3-5 h, Bulk 5-12 h | Archivo |
| **Glacier Deep Archive** | - | 180 días | Standard 12 h, Bulk 48 h | Archivo a largo plazo |
| **Intelligent-Tiering** | - | - | Según el tier | Patrón de acceso impredecible |

**Intelligent-Tiering** monitorea el uso y mueve cada objeto automáticamente entre tiers: Frequent Access, Infrequent
Access, Archive Instant Access, Archive Access y Deep Archive Access.

Los objetos se pueden mover entre clases de forma manual o con **S3 Lifecycle**. En general, cuanto más tarda el
acceso o menor es la disponibilidad, más barato es almacenar.

> 📝 **Nota del examen**: **todas** las clases tienen la misma durabilidad (99,999999999%, "11 nueves"). Lo que cambia
> es la disponibilidad, el costo y el tiempo de acceso. En **One Zone - IA** los datos viven en una sola AZ, por lo que
> se pierden si esa AZ se destruye.

### S3 Lifecycle Rules

Para mover objetos entre clases de forma automática se crean reglas de lifecycle:

- **Transition actions**: pasan el objeto a otra clase después de cierto tiempo (por ejemplo, 60 días después de
  haberse creado).
- **Expiration actions**: eliminan el objeto después de cierto tiempo.
- Las reglas se pueden limitar a un **prefijo** (por ejemplo `my_folder1/*`) o a los objetos con ciertos **tags**.

**S3 Analytics (Storage Class Analysis)**: analiza los patrones de acceso de los objetos **Standard** para recomendar
cuándo pasarlos a **Standard-IA**, y así decidir qué lifecycle rules crear o mejorar. Genera un reporte diario. No da
recomendaciones para One Zone-IA ni para Glacier Flexible Retrieval.

### S3 Event Notifications

S3 puede avisar cuando ocurre un evento en un bucket, por ejemplo `s3:ObjectCreated:*`, `s3:ObjectRemoved:*`,
`s3:ObjectRestore:*` o `s3:Replication`. Se pueden configurar los que se necesiten, por ejemplo
reaccionar solo cuando se crea una imagen `.jpg`.

- **Destinos**: **SNS**, **SQS**, **Lambda** y **Amazon EventBridge**.
- **Permisos**: al destino hay que adjuntarle una policy que le dé permiso a **S3** para publicar el evento (la access
  policy del topic o de la cola, y la resource-based policy de la Lambda). No es un rol del bucket.
- Cada configuración de notificación admite **un solo destino**, y un cambio tarda unos 5 minutos en aplicarse.
- Con **EventBridge** el evento se puede reenviar a muchos más servicios destino. Es también la forma de llegar a una
  cola **SQS FIFO**, que no se soporta directamente como destino.

### S3 Performance

- **Límites base**: S3 soporta al menos **3.500 requests por segundo** para PUT/COPY/POST/DELETE y **5.500** para
  GET/HEAD, **por prefijo**. No hay límite de prefijos en un bucket, así que repartir los objetos en más prefijos
  aumenta el throughput total.
- **Multi-part upload**: para archivos grandes se divide la subida en partes que se suben **en paralelo**.
- **S3 Transfer Acceleration**: acelera las transferencias de larga distancia hacia un bucket. El archivo se sube a un
  **edge location** cercano (los de CloudFront) y desde ahí viaja por la red privada de AWS hasta el bucket, que sigue
  estando en una sola región.
- **Byte-range fetches**: se piden **rangos de bytes** de un objeto (header `Range`) para paralelizar las descargas, o
  para traer solo una parte del archivo.

> 📝 **Nota del examen**: Transfer Acceleration mejora la **subida** desde lejos hacia un bucket. No sirve el contenido
> desde servidores cercanos al usuario: para eso se usa **CloudFront** o se replica el bucket a otra región.

### S3 Encryption

**Server-side encryption (SSE)**: S3 encripta el objeto al guardarlo y lo desencripta al leerlo. Hay cuatro variantes,
según quién maneja las keys:

| Tipo | Keys | Valor del header `x-amz-server-side-encryption` | Notas |
| :--- | :--- | :--- | :--- |
| **SSE-S3** | Administradas por S3 (AES-256) | `AES256` | Es el **default** para todo objeto nuevo |
| **SSE-KMS** | Guardadas en AWS KMS | `aws:kms` | Control de la key y auditoría con CloudTrail |
| **DSSE-KMS** | Guardadas en AWS KMS | `aws:kms:dsse` | **Dos capas** de encriptación |
| **SSE-C** | Las provee el cliente | (usa headers propios para la key) | Requiere **HTTPS** |

- **SSE-S3**: desde el 5 de enero de 2023, todos los objetos nuevos se encriptan con SSE-S3 sin costo extra y sin
  configurar nada. El header solo hace falta si se quiere indicar el tipo de forma explícita.
- **SSE-KMS**: el usuario puede crear y controlar la key, y las operaciones quedan registradas en **CloudTrail**. La
  contra es que cada operación usa la **API de KMS**, que tiene **costo** y **límites de requests por segundo**: con
  mucho tráfico puede haber throttling. Los **S3 Bucket Keys** reducen esas llamadas a KMS (y su costo) hasta en un 99%.
- **DSSE-KMS**: aplica **dos capas** de encriptación AES-256 con keys de KMS, pensado para cumplir normas de
  compliance que piden doble capa. Cuesta más que SSE-KMS por las llamadas extra a KMS.
- **SSE-C** (Customer-Provided Keys): la key la maneja el cliente **por fuera de AWS**. Se envía en cada request, por
  HTTPS obligatoriamente; AWS la usa para encriptar o desencriptar y la **descarta**, nunca la almacena.

> 📝 **Nota**: desde abril de 2026, SSE-C viene **deshabilitado por defecto** en los buckets nuevos de propósito
> general, y también en los existentes de cuentas que no tienen objetos encriptados con SSE-C. Hay que habilitarlo
> a propósito si se lo necesita.

**Client-side encryption**: el cliente encripta el objeto **antes** de enviarlo a S3 y lo desencripta al descargarlo.
AWS nunca ve el contenido sin encriptar ni maneja la key.

#### Encriptación en tránsito (HTTPS)

S3 acepta tanto **HTTP** como **HTTPS** (HTTPS cifra la conexión con TLS). Se recomienda usar siempre HTTPS, y para
**forzarlo** se agrega una bucket policy que **deniega** los requests cuando `aws:SecureTransport` es `false`:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyHTTP",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": ["arn:aws:s3:::mybucket", "arn:aws:s3:::mybucket/*"],
      "Condition": { "Bool": { "aws:SecureTransport": "false" } }
    }
  ]
}
```

### S3 CORS

**CORS (Cross-Origin Resource Sharing)** es un mecanismo de seguridad del **navegador** que define cuándo una página
cargada desde un origen puede pedir recursos a un origen distinto.

Un **origin** se compone de **esquema (protocolo) + host (dominio) + puerto**. Por ejemplo, en
`https://www.example.com` el puerto es 443 por ser https. Dos URLs son del mismo origen solo si coinciden las tres
partes:

- `https://example.com` y `https://www.example.com` son orígenes **distintos** (cambia el host).
- `http://example.com` y `https://example.com` son orígenes **distintos** (cambian el esquema y el puerto).

**Cómo funciona**: cuando una web carga recursos desde otro origen (por ejemplo, las imágenes están en un bucket de
S3), el navegador hace una request **cross-origin**.

1. El navegador agrega a la request el header `Origin` con el origen de la página.
2. Para ciertas requests (por ejemplo con métodos como `PUT` o headers personalizados) primero envía una consulta de
   **preflight** con el método `OPTIONS`, para preguntar qué se permite.
3. El bucket responde con los headers CORS, como `Access-Control-Allow-Origin`. Si el origen no está permitido, el
   navegador **bloquea** la respuesta.

**Configuración en S3**: se define una **configuración CORS en el bucket de destino**, el que recibe las requests (el
de las imágenes), no en el sitio que carga la página. Es un documento que indica los **orígenes permitidos** y los
**métodos HTTP** que se admiten para cada uno. Se puede permitir un origen específico indicando la URL, o `*` para
todos.

> 📝 **Notas**:
>
> - CORS lo aplica el **navegador**: herramientas como `curl` no lo respetan.
> - CORS **no otorga permisos**. Para que el objeto se pueda leer, igual hace falta que la bucket policy o IAM lo
>   permitan. CORS solo le dice al navegador que una página de otro origen puede leer la respuesta.
> - **Nota del examen**: si una pregunta describe un error del navegador al pedir un recurso de S3 desde otro dominio,
>   la solución es configurar **CORS en el bucket de destino**.

## Amazon CloudFront

> 🔗 **Documentación oficial**: [Amazon CloudFront Developer Guide](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Introduction.html)

**CloudFront** es el servicio de **CDN (Content Delivery Network)** de AWS. Incluye **cache** y **seguridad**, y se
destaca por su red global de **cientos de puntos de presencia** (edge locations): más de 700, más una capa de
**Regional Edge Caches**. El contenido se sirve desde el punto más cercano al usuario, así que llega muy rápido a
cualquier parte del mundo.

- **Regional Edge Caches**: caches intermedios entre los edge locations y el origen, que retienen el contenido más
  tiempo, incluso el que no es tan popular como para quedarse en un edge location.
- **Seguridad**: los edge locations ofrecen mitigación automática de ataques DDoS de capas 3 y 4.

### Orígenes

CloudFront funciona como la **puerta de entrada** hacia distintos orígenes de datos:

- **S3 buckets**: para servir (y también subir) archivos a través de CloudFront.
- **VPC Origin**: para aplicaciones en **subnets privadas** de una VPC: un **ALB**, un **NLB** o instancias **EC2**
  que no son accesibles desde internet y solo se alcanzan a través de CloudFront.
- **Custom Origin (HTTP)**: cualquier aplicación accesible por HTTP.

Los orígenes pueden estar en redes **públicas** o **privadas** (VPC):

- **Origen en una VPC**: el usuario solo puede llegar a la aplicación a través de CloudFront, lo que es más seguro y
  casi no requiere configuración.
- **Origen público**: hay que evitar que se pueda acceder directo, salteándose CloudFront. Dos formas de lograrlo:
  - Un **security group** que permita solo el tráfico de CloudFront, usando la **managed prefix list de CloudFront**
    (AWS mantiene ahí las IP de los edge locations, no hace falta cargarlas a mano).
  - Un **header personalizado con un valor secreto** que CloudFront agrega a cada request, y que el origen verifica.

### Caching

El cache ocurre en **cada edge location**.

- **Cache key**: identificador único de cada objeto dentro del cache. Define si una request es un cache hit.
- **Cache policy**: permite agregar más datos a la cache key (query strings, headers y cookies). Con las query strings
  se puede elegir incluir **todas**, solo una **lista permitida (allowlist)**, **todas menos algunas excepciones**, o
  **ninguna**.
- **Origin request policy**: define qué datos se envían al origen **sin** incluirlos en la cache key. Todo lo que está
  en la cache key también viaja al origen; esta policy permite sumar headers, cookies o query strings extra.
- **Invalidación**: la **Invalidation API** quita objetos del cache antes de que venzan, de forma total o parcial. Se
  indica una ruta, y con un `*` al final se invalidan varios archivos a la vez.

### Cache Behaviors

Un **cache behavior** define cómo trata CloudFront las URLs que coinciden con un **patrón de ruta (path pattern)**:
cada patrón puede tener su propio origen y su propia configuración de cache. Siempre existe un **default behavior**,
con patrón `*`, que se aplica a todo lo que no coincide con otro.

### Geo Restriction

Permite **restringir el acceso por país** a toda la distribución, con una de dos listas:

- **Allowlist**: solo pueden acceder los países indicados.
- **Blocklist**: se bloquea a los países indicados.

Los usuarios de un país no permitido reciben un error **403**. Sirve, por ejemplo, cuando no se puede ofrecer el
contenido en algún país por derechos de copyright.

### Signed URLs y Signed Cookies

Sirven para dar acceso a contenido **solo a ciertos usuarios**, por ejemplo contenido premium para quienes pagaron.

- **Signed URL**: da acceso a **una URL (archivo) específica**.
- **Signed Cookie**: da acceso a **muchas URLs a la vez**.

Para generarlas se define una **policy** que puede incluir la **fecha de expiración**, un **rango de IP** permitido y
el **firmante de confianza (trusted signer)**, es decir, quién puede firmar las URLs.

> 📝 **Trusted key group**: para definir al firmante, AWS recomienda crear un **key group** en CloudFront (con las
> claves públicas con las que CloudFront verifica la firma) en lugar del método anterior, un **CloudFront key pair**
> asociado a una cuenta de AWS.

### Price Classes

CloudFront cobra distinto según el edge location desde el que se descargan los datos. Para reducir costos se elige una
**price class**, que limita los edge locations que se usan. No se pueden elegir edge locations sueltos, solo una de las
tres clases:

| Clase | Edge locations incluidos |
| :--- | :--- |
| **Price Class All** | Todos |
| **Price Class 200** | La mayoría, sin los más caros (no incluye Sudamérica ni Australia/Nueva Zelanda) |
| **Price Class 100** | Solo las regiones más baratas (principalmente Norteamérica y Europa) |

> 📝 **Nota**: las price classes no bloquean usuarios. Quienes están en regiones excluidas se siguen sirviendo, pero
> desde un edge location más lejano, con peor rendimiento. Para bloquear países se usa la **Geo Restriction**.
>
> 📝 **Nota del examen**: **CloudFront** acelera la **entrega** de contenido desde puntos cercanos al usuario (cache en
> el borde). **S3 Transfer Acceleration** acelera la **subida** hacia un bucket. No son lo mismo.
>
> 📝 **Signed URL de CloudFront vs presigned URL de S3**: la de CloudFront se firma con un **key group** y sirve para
> cualquier origen. La de S3 usa los **permisos de quien la creó** y solo sirve para objetos de S3.

## Amazon ECS (Elastic Container Service)

> 🔗 **Documentación oficial**: [Amazon ECS Developer Guide](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/Welcome.html)

**ECS** permite correr **contenedores Docker** en AWS. Cada contenedor (o grupo de contenedores) se ejecuta como una
**ECS Task**, y los contenedores corren dentro de un **cluster**.

### Task Definition

La **task definition** es un archivo JSON que especifica cómo correr uno o más contenedores. Define:

- **Image name**: la imagen de Docker a usar.
- **Port binding**: el puerto del contenedor y el del host.
- **Memory y CPU** requeridos.
- **Variables de entorno**.
- **Información de red (networking)**.
- **IAM Role** de la task.
- **Configuración de logging**, por ejemplo hacia CloudWatch.

### Launch Types: EC2 y Fargate

Hay dos formas de correr las tasks. El curso recomienda usar **Fargate**.

| Característica | EC2 launch type | Fargate launch type |
| :--- | :--- | :--- |
| Infraestructura | Se levantan **instancias EC2** dentro del cluster | **Serverless**: no hay EC2 que administrar |
| Quién gestiona las EC2 | **Nosotros** (parches, capacidad, escalado) | AWS |
| Contenedores | Corren dentro de las EC2, con un **ECS Agent** que los gestiona | AWS levanta y gestiona los contenedores |
| Permisos del agente | **EC2 Instance Profile** (lo usa el ECS Agent) | No hay instance profile |

### IAM Roles en ECS

Hay tres roles que no hay que confundir:

- **EC2 Instance Profile** (container instance role): solo en **EC2 launch type**. Lo usa el **ECS Agent** para llamar
  a la API de ECS, enviar logs a CloudWatch, descargar imágenes de ECR, etc.
- **Task Role**: se define **en la task definition** y da permisos a **la aplicación que corre dentro del
  contenedor** (por ejemplo, leer de S3 o escribir en DynamoDB). Funciona igual en EC2 y en Fargate. Conviene crear
  uno distinto por cada servicio o task, con los permisos mínimos.
- **Task Execution Role**: la usa **ECS (o el agente de Fargate)** para preparar y lanzar la task: descargar la imagen
  desde ECR, enviar logs a CloudWatch y obtener secrets de Secrets Manager o Parameter Store.

> 📝 **Nota del examen**: **Task Role** = permisos de **tu código**. **Task Execution Role** = permisos del
> **servicio ECS** para arrancar la task. En Fargate no existe el instance profile.

### Cómo se lanzan las tasks

Además de lanzarlas a mano o como parte de un servicio, se pueden crear en respuesta a eventos externos. Por ejemplo,
una regla de **EventBridge** que lance una task, o un escalado según la cantidad de mensajes acumulados en una cola
**SQS**.

### Integración con Load Balancers

- **ALB (Application Load Balancer)**: es el recomendado para la mayoría de los casos. Soporta **dynamic host port
  mapping**, que permite correr varias tasks del mismo servicio en una misma instancia, y routing por path.
- **NLB (Network Load Balancer)**: se recomienda solo para aplicaciones con **alto throughput o alto rendimiento**.
- **CLB (Classic Load Balancer)**: no se recomienda. No soporta dynamic port mapping y no es compatible con Fargate.

### Data Volumes

Para **persistir datos** se recomienda **EFS**, que funciona tanto con EC2 como con Fargate y permite que varias tasks
compartan el mismo almacenamiento, aunque estén en distintas AZ.

- ECS también se integra con **EBS** (volúmenes por task).
- El almacenamiento propio del contenedor y los **bind mounts** son **efímeros**: los datos se pierden cuando la task
  se detiene.
- **S3** se puede usar para guardar datos, pero desde el código de la aplicación (con el SDK), no como un disco montado
  en la task definition de la forma clásica.

### ECS Auto Scaling

Permite **sumar y restar tasks** automáticamente. Usa **Application Auto Scaling** y puede escalar según:

- **ECSServiceAverageCPUUtilization**: uso promedio de CPU del servicio.
- **ECSServiceAverageMemoryUtilization**: uso promedio de memoria (scale on RAM).
- **ALBRequestCountPerTarget**: cantidad de requests por task, una métrica que viene del ALB.

Tipos de política de escalado:

- **Target Tracking**: mantiene una métrica cerca de un valor objetivo (puede ser una métrica de CloudWatch).
- **Step Scaling**: se dispara con una **alarma de CloudWatch**, con escalones según cuánto se supere el umbral.
- **Scheduled Scaling**: según un horario conocido.

> 📝 **Ojo con el nivel de escalado**: el auto scaling de ECS actúa a **nivel de task** (contenedores), no de
> instancias. En **Fargate** alcanza con eso, porque no hay EC2. En **EC2 launch type** hay que escalar también las
> **instancias EC2** del cluster. Para hacerlo se usa un **Auto Scaling Group** o un **ECS Cluster Capacity Provider**,
> que administra la capacidad por nosotros. Por eso se recomienda Fargate.

### Actualizar un servicio de ECS

Al actualizar un servicio (rolling update) se definen dos parámetros que controlan cuántas tasks se reemplazan a la vez:

- **Minimum healthy percent**: mínimo de tasks sanas que deben seguir corriendo durante el update, como porcentaje de
  la cantidad deseada.
- **Maximum percent**: máximo de tasks (corriendo o iniciando) permitidas durante el update, como porcentaje de la
  cantidad deseada.

ECS termina y levanta tasks **dentro de ese rango** hasta completar la actualización de a poco. Por ejemplo, con mínimo
50% y máximo 100% reemplaza la mitad de las tasks por vez. Con mínimo 100% y máximo 200% primero levanta las nuevas y
después baja las viejas.

## Amazon ECR (Elastic Container Registry)

> 🔗 **Documentación oficial**: [Amazon ECR User Guide](https://docs.aws.amazon.com/AmazonECR/latest/userguide/what-is-ecr.html)

**ECR** es un repositorio para **almacenar imágenes de contenedores**, de forma **privada o pública**. Está integrado
con ECS y el acceso se controla con **IAM** (junto con las policies del repositorio). Algunas funciones:

- **Escaneo de vulnerabilidades** de las imágenes.
- **Image tags**, para identificar y versionar las imágenes.
- **Image lifecycle policies**, que expiran las imágenes viejas o sin uso.
- **Tag immutability**, para impedir que un tag existente se sobrescriba.

## Amazon EKS (Elastic Kubernetes Service)

> 🔗 **Documentación oficial**: [Amazon EKS User Guide](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html)

**EKS** es el servicio administrado de **Kubernetes** en AWS. Cumple un rol parecido al de ECS (correr contenedores),
pero usa Kubernetes en lugar del orquestador propio de AWS. Es especialmente útil para **migrar aplicaciones que ya
corren en Kubernetes** (por ejemplo, en servidores on-premise).

## AWS Elastic Beanstalk

> 🔗 **Documentación oficial**: [AWS Elastic Beanstalk Developer Guide](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/Welcome.html)

**Elastic Beanstalk** es un servicio con una visión **centrada en el desarrollador** para manejar el deploy de
aplicaciones en AWS. Permite definir en un solo lugar todos los servicios que usa la aplicación (EC2, ASG, ELB, RDS,
etc.), sin perder el control sobre cómo se comunican entre sí ni sobre el código de cada uno.

- **No tiene costo propio**: se paga solo por los recursos que usa (EC2, load balancer, etc.).
- Una **aplicación** de Beanstalk es una colección de componentes: environments, versiones, configuraciones, etc.

### Environments y tiers

Un **environment** corre **una versión de la aplicación a la vez**. Se pueden crear varios, por ejemplo `dev`, `test`
y `prod`. Cada environment tiene uno de dos tiers:

- **Web Server Environment Tier**: una aplicación web, con un **ELB**, instancias **EC2** y un **ASG**.
- **Worker Environment Tier**: el input llega desde una cola de **SQS** y se procesa con instancias **EC2** y un
  **ASG**. No lleva load balancer.

### Deployment Policies

Opciones al actualizar una aplicación:

| Política | Cómo funciona | Downtime y costo |
| :--- | :--- | :--- |
| **All at once** | Se actualiza todo a la vez: se frena la app que está corriendo y se levanta la nueva | La app **se cae unos minutos**. Es la más rápida y no tiene costo extra |
| **Rolling** | Se actualiza por lotes: cuando las instancias de un lote están sanas, se sigue con el siguiente | La capacidad **baja** durante el deployment. Sin costo extra |
| **Rolling with additional batch** | Como Rolling, pero primero se levanta un **lote extra** y después se van apagando las viejas | Mantiene la capacidad completa. Cuesta un poco más durante el deployment |
| **Immutable** | Se crea la app en un **ASG temporal nuevo** y, cuando todo está sano, se pasan las instancias nuevas al ASG original | **Zero downtime** y rollback sencillo (basta terminar el ASG temporal). Cuesta más, pero solo mientras dura el deployment |
| **Traffic splitting** | Hace un deployment immutable y envía **un porcentaje del tráfico** a las instancias nuevas durante un tiempo | Sirve para **canary testing**: probar mejoras con poco tráfico antes de pasar todo. El tráfico se maneja con un ALB |

### Blue/Green

**Blue/Green no es una política de deployment de Beanstalk**: se hace **a mano**. Se crea un **environment nuevo**
(green), se prueba, y cuando está listo se usa **Swap environment URLs** para intercambiar las URL de los dos
environments. El cambio de tráfico es de golpe, no gradual (para ir enviando tráfico de a poco se usa Traffic
splitting).

### EB CLI

Existe el **Elastic Beanstalk CLI (EB CLI)**, con comandos propios que ayudan a automatizar los deploys.

### Extensiones (`.ebextensions`)

Sirven para agregar recursos o personalizar el environment más allá de lo que ofrecen los tiers.

- Se ubican en una carpeta llamada **`.ebextensions/`** en la **raíz del proyecto**.
- Cada archivo tiene extensión **`.config`** y su contenido va en **YAML** o **JSON** (AWS recomienda YAML).
- Beanstalk se apoya en **CloudFormation**: lo que se define en `.ebextensions/` se agrega a la plantilla de
  CloudFormation del environment, por lo que se pueden definir recursos de CloudFormation.

### Clonar un environment y base de datos

- Se puede **clonar** un environment de Beanstalk. En el caso de RDS, **no se copian los datos** de la base.
- **Cambiar el load balancer**: se crea a mano un environment nuevo, sin clonar, con el nuevo load balancer, y luego
  se hace el **swap** de URLs.
- **RDS**: si la base se crea dentro de Beanstalk, queda atada al environment, y si este se termina **se pierde la
  base**. Por eso se recomienda crear la DB **por fuera** y conectarla con un **connection string**.

> 📝 **Nota del examen**: si una pregunta pide **cero downtime** al actualizar, la respuesta es **Immutable** (o
> Blue/Green). Para **probar con una parte del tráfico**, **Traffic splitting**.

## AWS CloudFormation

> 🔗 **Documentación oficial**: [AWS CloudFormation User Guide](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/Welcome.html)

**CloudFormation** es una forma de crear **infraestructura como código (IaC)**: se declara en un archivo todo lo que se
quiere crear y CloudFormation lo crea, respetando el orden que imponen las **dependencias** entre los recursos.

- Un **template** es el archivo que describe la infraestructura (el plano).
- Un **stack** es el conjunto de recursos creados a partir de un template, que se administra como una sola unidad.
- Los recursos de un stack quedan identificados con **tags**, así que se pueden crear y eliminar todos juntos al
  borrar el stack.
- El template se sube a **S3** y CloudFormation va creando los recursos definidos en él.

### Secciones de un template

| Sección | Para qué sirve |
| :--- | :--- |
| `AWSTemplateFormatVersion` | Versión del **formato** de template. Es **opcional** y el único valor válido es `2010-09-09` |
| `Description` | Un comentario sobre lo que crea el template |
| `Resources` | Define los recursos a crear. Es la **única sección obligatoria** |
| `Parameters` | **Inputs dinámicos** que se pasan al crear el stack |
| `Mappings` | **Variables estáticas** definidas en el propio template |
| `Conditions` | Condiciones que controlan si se crea un recurso |
| `Outputs` | Valores que **referencian lo que se creó** (por ejemplo, un ID o una URL) |

Existen otras secciones opcionales (por ejemplo `Metadata` o `Transform`).

> 📝 **Nota del examen**: de todas las secciones, solo **`Resources`** es obligatoria. `AWSTemplateFormatVersion` no es
> la versión de tu template: indica la versión del formato.

### Permisos: service role

Se puede asignar un **service role** (rol de IAM) a un stack para que **CloudFormation use ese rol** al crear los
recursos. Así, los usuarios no necesitan permisos propios sobre esos servicios: les alcanza con permisos de
CloudFormation y con poder pasar el rol (`iam:PassRole`). Es útil, por ejemplo, para que la creación de recursos en
producción solo se haga a través de CloudFormation.

Si no hay un service role, CloudFormation usa las credenciales del usuario que lanzó la operación.

### Stack Policies

Una **stack policy** es un documento JSON que define **qué actualizaciones se permiten** sobre los recursos de un
stack, por ejemplo para evitar que un stack modifique un servicio ya creado.

- Al configurar una stack policy, **todos los recursos quedan protegidos por defecto**.
- Para permitir actualizaciones se agregan statements `Allow`, y un `Deny` explícito sobre un recurso (por ejemplo, la
  base de datos de producción) tiene prioridad.
- Protege contra actualizaciones hechas **a través de CloudFormation**, no contra cambios hechos directamente sobre
  el recurso fuera de CloudFormation.

### Eliminar un stack con buckets de S3

CloudFormation **no puede eliminar un bucket que tiene objetos**: primero hay que **vaciarlo**, o la eliminación del
stack falla. Si no se puede vaciar, se puede **retener** el recurso al borrar el stack.

## Amazon SQS (Simple Queue Service)

> 🔗 **Documentación oficial**: [Amazon SQS Developer Guide](https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/welcome.html)

Una **cola SQS** es una lista de mensajes. Los **producers** envían mensajes a la cola y los **consumers** los reciben y
los procesan. Sirve para **desacoplar aplicaciones**: el producer no depende de que el consumer esté disponible en ese
momento.

- Puede haber **todos los producers y consumers** que se necesiten, y la cola puede acumular **todos los mensajes**
  que hagan falta.
- El consumer tiene que **borrar el mensaje** de la cola cuando termina de procesarlo. Si no lo borra, el mensaje
  vuelve a ser visible después del visibility timeout.
- **Retención**: por defecto **4 días**, con un mínimo de 1 minuto y un máximo de **14 días**. Pasado ese tiempo, el
  mensaje se elimina.
- **Tamaño máximo por mensaje**: **1 MiB (1.024 KB)**. Para mensajes más grandes se guarda el contenido en **S3** y por
  SQS se envía un puntero (referencia) al objeto.

> 📝 **Nota**: hasta agosto de 2025 el límite era de 256 KB. Si el curso menciona 256 KB, está desactualizado.

### Standard vs FIFO

| Característica | Standard | FIFO |
| :--- | :--- | :--- |
| Throughput | Casi **ilimitado** | **300 msg/s** sin batching, **3.000 msg/s** con batching |
| Entrega | **At-least-once**: puede haber mensajes duplicados | Sin duplicados (exactly-once processing) |
| Orden | De mejor esfuerzo: puede llegar desordenado | **First In, First Out**: los mensajes salen en orden |

### Visibility Timeout

Cuando un consumer recibe un mensaje, este queda **invisible para los demás consumers** durante el **visibility
timeout**, que por defecto es de **30 segundos**.

- Si el consumer necesita más tiempo, debe llamar a la API **`ChangeMessageVisibility`** para ampliarlo (hasta un
  máximo de 12 horas).
- Si el tiempo se agota sin que el mensaje se haya borrado, vuelve a ser visible y **otro consumer lo recibe**, lo que
  genera un procesamiento duplicado.

### Long Polling

Cuando un consumer pide mensajes puede esperar a que **lleguen** en lugar de recibir una respuesta vacía enseguida:

- **Short polling**: responde de inmediato, aunque no haya mensajes.
- **Long polling**: el consumer espera hasta **20 segundos** como máximo a que llegue un mensaje.

Se recomienda **long polling** porque **reduce las respuestas vacías**, baja la cantidad de llamadas a la API (y su
costo) y disminuye la latencia.

### Dead Letter Queue (DLQ)

Una **DLQ** es una cola que guarda los mensajes que **fallaron muchas veces** al procesarse. Por ejemplo, un mensaje
con un error que el consumer nunca logra procesar: después de superar un **umbral de intentos de recepción** se envía a
la DLQ, para analizarlo más adelante y depurar el problema sin que bloquee la cola principal.

### Seguridad y acceso

- **Encriptación en reposo**: **SSE-SQS** (keys administradas por SQS) o **SSE-KMS** (keys de AWS KMS).
- **Encriptación en tránsito**: llamadas por **HTTPS**.
- **Client-side encryption**: el cliente encripta el mensaje antes de enviarlo.
- **Control de acceso**: con **políticas IAM** o con **access policies propias de SQS** (policies adjuntas a la cola).
- **Acceso entre cuentas**: se aplica una **policy a la cola** que permite el acceso a otra cuenta.

> 📝 **S3 enviando eventos a una cola de otra cuenta**: la cola necesita una **policy que permita al servicio S3 enviar
> mensajes**. Si la cola usa SSE con KMS, hace falta una **key administrada por el cliente** (no sirve la key
> administrada por AWS) y darle permisos a S3 sobre esa key.

## Amazon SNS (Simple Notification Service)

> 🔗 **Documentación oficial**: [Amazon SNS Developer Guide](https://docs.aws.amazon.com/sns/latest/dg/welcome.html)

**SNS** funciona con el modelo **publish/subscribe**: un **publisher** envía un mensaje a un **topic** de SNS y SNS lo
entrega a **todos los suscriptores** del topic. A diferencia de SQS (donde el consumer busca los mensajes), SNS los
**empuja (push)**. Los suscriptores pueden ser:

- **SQS**
- **Lambda**
- **Amazon Data Firehose**
- **Email**
- **SMS** y notificaciones **mobile push**
- **Endpoints HTTP y HTTPS**

SNS también puede **recibir notificaciones de otros servicios de AWS** como origen de los mensajes.

- Un topic estándar admite hasta **12,5 millones de suscripciones**.
- SNS puede enviar mensajes **entre regiones** hacia colas SQS y funciones Lambda.
- Por defecto un topic acepta mensajes de hasta **256 KiB**. Si se configura un límite mayor, solo admite
  suscripciones de Firehose, SQS y Lambda.
- SNS no es un almacén de mensajes: los entrega a los suscriptores y no los retiene para leerlos más tarde.

### Patrón fan-out (SNS + SQS)

Si un producer necesita enviar el mismo mensaje a **muchas colas SQS**, conviene poner un **SNS en el medio**: el
producer publica **una sola vez** en el topic y SNS lo distribuye a cada cola suscrita. Así el producer no necesita
conocer cada cola, y se pueden agregar o quitar colas sin tocar su código.

## Amazon Kinesis

> 🔗 **Documentación oficial**:
> [Amazon Kinesis Data Streams](https://docs.aws.amazon.com/streams/latest/dev/introduction.html) ·
> [Amazon Data Firehose](https://docs.aws.amazon.com/firehose/latest/dev/what-is-this-service.html) ·
> [Managed Service for Apache Flink](https://docs.aws.amazon.com/managed-flink/latest/java/what-is.html)

### Kinesis Data Streams

Servicio que **recibe y transmite datos (streaming) en tiempo real**.

- **Producers**: una aplicación que envía streaming de datos (con el SDK o la **Kinesis Producer Library, KPL**), o el
  **Kinesis Agent**, que se instala en un servidor y envía métricas y logs al stream.
- **Consumers**: aplicaciones (con la **Kinesis Client Library, KCL**), funciones **Lambda**, **Amazon Data Firehose** o
  **Managed Service for Apache Flink**.
- **Retención**: **24 horas por defecto, hasta 365 días**. Los registros son **inmutables** y los consumers pueden
  **reprocesarlos (replay)** mientras no expiren.
- **Tamaño de registro**: **1 MiB por defecto**. Admite hasta **10 MiB** si se habilita para el stream.
- **Orden**: los registros con la misma **partition key** van al mismo **shard**, y el orden se garantiza **dentro de
  cada shard**.

**Capacity modes**:

| Modo | Cómo funciona | Cobro |
| :--- | :--- | :--- |
| **Provisioned** | Se elige la cantidad de **shards**. Cada shard soporta **1 MB/s de entrada y 2 MB/s de salida**. Se escala **manualmente** | Por cada shard |
| **On-demand** | No hay que administrar la capacidad: **escala automáticamente** según el tráfico (el curso menciona el pico de los últimos 30 días) | **Standard**: por stream por hora, más el volumen de datos. **Advantage**: sin cargo fijo por stream y con ingesta de menor costo |

**Modos de consumo**: con **shared throughput** (standard) los consumers se reparten el throughput del shard. Con
**enhanced fan-out**, cada consumer recibe hasta **2 MB/s por shard con throughput dedicado**.

### Amazon Data Firehose

Servicio para **enviar datos de streaming a destinos específicos**, sin administrar infraestructura.

- **Producers**: Kinesis Agent, el SDK, aplicaciones, Kinesis Data Streams, CloudWatch y AWS IoT.
- Los datos se pueden **transformar en el camino** (por ejemplo, con una función Lambda).
- Los registros con error se pueden guardar en un bucket de **S3**.
- **Destinos**: **S3**, **Redshift** (primero entrega a S3 y luego hace un `COPY`), **OpenSearch**, **partners de terceros**
  (como Datadog, MongoDB o Splunk) y **endpoints HTTP personalizados**.
- Es **near real-time**: acumula los datos en un **buffer** (por tamaño o por tiempo) antes de entregarlos.

### Kinesis Data Streams vs Amazon Data Firehose

| Característica | Kinesis Data Streams | Amazon Data Firehose |
| :--- | :--- | :--- |
| Qué hace | Streaming de datos, con producers y consumers propios | Carga datos en destinos (S3, Redshift, OpenSearch, terceros, HTTP) |
| Latencia | Tiempo real | **Near real-time** |
| Capacidad | Provisioned u on-demand | **Fully managed**, escala automáticamente |
| Almacenamiento | Hasta **365 días** | **No almacena** datos |
| Replay | **Sí** | **No** |

### Managed Service for Apache Flink

**Apache Flink** es un framework para procesar streams de datos, que se programa en **Java, Scala, Python o SQL**. El
servicio (antes llamado Kinesis Data Analytics) administra el **auto scaling**, el **cómputo en paralelo** y los
recursos. Respalda el estado de la aplicación con **checkpoints y snapshots**.

> 📝 **Nota del examen**: **Flink no lee datos desde Firehose**. Firehose se usa solo como **destino (sink)**: Flink
> puede escribir su salida en Firehose, pero no tomarlo como origen de datos.

## SQS vs SNS vs Kinesis

| Característica | SQS | SNS | Kinesis Data Streams |
| :--- | :--- | :--- | :--- |
| Modelo | **Pull**: el consumer pide los mensajes | **Push**: envía a los suscriptores | Los consumers leen del stream |
| Datos | Se **borran** al ser consumidos | **No persisten** | Se **retienen** hasta 365 días y se pueden reprocesar (**replay**) |
| Consumers | Varios workers | Hasta 12,5 millones de suscripciones por topic | Shared o **enhanced fan-out** |
| Capacidad | No hay que provisionar throughput | No hay que provisionar throughput | **Provisioned** u **on-demand** |
| Orden | Con **FIFO** | Se integra con SQS FIFO | Por **shard** |
| Otros | Puede configurar un **delay** de entrega | Se integra con SQS (fan-out) | Orientado a **big data en tiempo real** |

## Amazon CloudWatch

> 🔗 **Documentación oficial**: [Amazon CloudWatch User Guide](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/WhatIsCloudWatch.html)

**CloudWatch** sirve para **recolectar y seguir métricas**, **monitorear y analizar archivos de logs**, **enviar
notificaciones** de ciertos eventos y **reaccionar con alarmas** a eventos y métricas en tiempo real.

### Métricas

- Cada servicio de AWS publica métricas por defecto, y además se pueden crear **métricas custom**.
- Se pueden armar **dashboards** para visualizarlas.
- **Free tier**: incluye **10 métricas custom** y **10 alarmas**, y hasta **3 dashboards con 50 métricas cada uno**,
  además de **5 GB de logs** y 1 millón de requests a la API por mes.
- Se pueden enviar métricas con un timestamp **pasado o futuro**: CloudWatch acepta hasta **dos semanas hacia atrás** y
  **dos horas hacia adelante**, y no devuelve error por eso.

### Logs

- Los logs se organizan en un **log group** (el nombre, que representa una aplicación) y dentro de él **log streams**
  (el log en sí, por ejemplo un archivo de log o la salida de una aplicación o contenedor).
- Se puede definir cuánto **tiempo se guardan** (o dejar que nunca expiren).
- Se pueden enviar a **S3** (export), **Kinesis Data Streams**, **Amazon Data Firehose**, **Lambda** y
  **OpenSearch** (estos cuatro últimos mediante *subscription filters*).
- Se encriptan y se puede usar una key de **KMS**.
- Para consultarlos se usa **Logs Insights**, que permite filtrar con una **query** qué logs mostrar.

**Origen de los logs**:

- **SDK** y el **CloudWatch agent**, instalado en servidores como EC2 o en servidores on-premise.
- **Elastic Beanstalk**: logs de la aplicación.
- **ECS**: logs de los contenedores.
- **AWS Lambda**: logs de las funciones.
- **API Gateway**: las requests.
- **CloudTrail**: logs filtrados por una regla.
- **Route 53**: las consultas DNS.

> 📝 **CloudWatch agent**: el **unified agent** recolecta **logs y métricas** y es el que se debe usar. El agente
> anterior, que solo recolectaba logs, está **deprecado y sin soporte**.

### Alarmas

Una alarma vigila **una métrica** y tiene tres estados: `OK`, `ALARM` e `INSUFFICIENT_DATA`. Puede disparar:

- **Acciones de EC2**: por ejemplo, detener, terminar, reiniciar o recuperar una instancia.
- **Acciones de EC2 Auto Scaling**: lanzar o terminar instancias.
- **SNS**: para integrarse con otros servicios.

Para alarmar según **varias métricas** se crean las alarmas individuales y luego una **composite alarm**, que combina
sus estados mediante una **expresión de reglas**. Una composite alarm **no evalúa métricas**: solo mira el estado de
las alarmas que referencia.

- En la expresión se indica, para cada alarma referenciada, **en qué estado** debe estar (`ALARM`, `OK` o
  `INSUFFICIENT_DATA`).
- Esas condiciones se combinan con los operadores **`AND`**, **`OR`** y **`NOT`**, y se pueden agrupar con
  **paréntesis**.

Por ejemplo, para que se dispare solo cuando **todas** las alarmas elegidas están en `ALARM` se combinan con `AND`.
Con `OR` bastaría con que **una** de ellas esté en `ALARM`.

### Synthetics Canary

Un **canary** es un script, programado para correr periódicamente, que **simula el comportamiento de los usuarios** y
envía una alarma si detecta un error.

## Amazon EventBridge (antes CloudWatch Events)

> 🔗 **Documentación oficial**: [Amazon EventBridge User Guide](https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-what-is.html)

Sirve para **programar scripts** (ejecutarlos cada cierto tiempo) y para **reaccionar a eventos**. Los eventos se
pueden **filtrar** y, una vez recibidos, se envían como **JSON** a múltiples destinos.

Puede recibir eventos de:

- **Servicios de AWS**.
- **Partners de AWS** (SaaS).
- **Aplicaciones propias** (custom).

## AWS X-Ray

> 🔗 **Documentación oficial**: [AWS X-Ray Developer Guide](https://docs.aws.amazon.com/xray/latest/devguide/aws-xray.html)

Sirve para **ver errores y el rendimiento** de una aplicación, y es muy útil en aplicaciones divididas en
**microservicios**. Permite ver el **flujo completo de una request**, desde que el usuario realiza la acción y por todos
los servicios por los que pasa, para **encontrar dónde falla**.

**Cómo habilitarlo** (disponible para Java, Python, Go, Node.js y .NET):

1. Usar el **SDK de X-Ray** en el código. Captura las llamadas a servicios de AWS, requests HTTP, llamadas a bases de
   datos y a colas SQS.
2. Instalar el **X-Ray daemon** en el servidor donde corre la aplicación. El SDK le envía los datos al daemon, y este
   los envía a X-Ray.
3. En **EC2**, además, hay que asignar un **IAM role** con permisos.
4. En **Lambda** **no** se instala el daemon: se habilita el **tracing activo** en la configuración de la función y se
   le da un IAM role con permisos.

> 📝 **Novedad**: desde el 25 de febrero de 2026, los **SDKs y el daemon de X-Ray están en modo mantenimiento** (solo
> reciben correcciones de seguridad) y AWS recomienda usar **OpenTelemetry**. El curso enseña la forma clásica con SDK y
> daemon.

## AWS CloudTrail

> 🔗 **Documentación oficial**: [AWS CloudTrail User Guide](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-user-guide.html)

Sirve para **monitorear las llamadas a las APIs** y **auditar los cambios** en los recursos de AWS. Está **habilitado por
defecto** y guarda el historial de las llamadas y eventos hechos desde la consola, el SDK, el CLI y los servicios de
AWS.

- El **event history** conserva los **últimos 90 días** de eventos de gestión, por región. Para guardarlos por más
  tiempo se crea un **trail** que los envíe a **S3** o a **CloudWatch Logs**, donde se pueden analizar.
- Funciona en todas las regiones.
- Si un recurso fue eliminado, **CloudTrail es el primer lugar donde investigar**.

### CloudTrail vs CloudWatch vs X-Ray

| Servicio | Para qué sirve |
| :--- | :--- |
| **CloudTrail** | **Auditar** las llamadas de usuarios, servicios y consola de AWS, por ejemplo para detectar llamadas no autorizadas |
| **CloudWatch** | Obtener **métricas, logs y alarmas** |
| **X-Ray** | Analizar el **trazado de requests**: mapa de visualización de latencia, errores y fallas, y seguimiento de cada request |

## AWS Lambda

> 🔗 **Documentación oficial**: [AWS Lambda Developer Guide](https://docs.aws.amazon.com/lambda/latest/dg/welcome.html)

**Lambda** es un servicio para crear **funciones que se ejecutan sin administrar servidores**. Corren **on-demand** y,
a diferencia de EC2, **escalan automáticamente**.

- **Timeout**: hasta **15 minutos (900 segundos)** por ejecución en las funciones estándar.
- **Precio**: se paga **por request** y por **tiempo de cómputo**.
- **Free tier**: **1 millón de requests** y **400.000 GB-segundos** de cómputo por mes.
- **Lenguajes**: Node.js, Python, Java, .NET (C#) y Ruby como runtimes administrados. Otros lenguajes, como Rust o Go,
  se usan con un **runtime OS-only** (custom runtime).
- Se integra con **muchos servicios de AWS**, se **monitorea fácil con CloudWatch** y es fácil darle más recursos a
  cada función.

> 📝 **Novedad**: la documentación actual llama **Lambda Event Functions** al modelo clásico de funciones y suma otros
> modelos (como Web Functions y Managed Instances). El límite de 15 minutos aplica a las funciones estándar.

### Integraciones principales

- **API Gateway**: entrada REST para nuestra API.
- **Kinesis**: procesar datos en streaming.
- **DynamoDB**: como trigger, cuando algo cambia en la tabla se dispara la Lambda (con DynamoDB Streams).
- **S3**: dispara una Lambda, por ejemplo, cuando se sube un archivo.
- **CloudFront**: ejecutar lógica desde el borde (Lambda@Edge).
- **CloudWatch Events / EventBridge**: eventos que disparan la Lambda.
- **CloudWatch Logs**: procesar los logs y enviar información a donde haga falta.
- **SNS**: reaccionar ante notificaciones.
- **SQS**: procesar mensajes de una cola.
- **Cognito**: reaccionar a eventos de autenticación.

Ejemplos comunes:

- Se sube una **imagen a S3**, lo que dispara una Lambda que genera un **thumbnail** y guarda la metadata en
  **DynamoDB**.
- Una **regla de EventBridge con un schedule** dispara una Lambda para ejecutar una tarea cada cierto tiempo.

### Tipos de invocación

| Tipo | Quién la origina | Cómo funciona | Errores y reintentos |
| :--- | :--- | :--- | :--- |
| **Síncrona** | SDK, CLI, API Gateway, ALB | El que invoca **espera** a que la Lambda procese y responda | Los gestiona **quien invoca** |
| **Asíncrona** | S3, SNS, EventBridge | Lambda recibe el evento y lo procesa | Lambda **reintenta** y se puede usar una **DLQ** o **destinations** |
| **Event source mapping** | Kinesis Data Streams, SQS, SQS FIFO, DynamoDB Streams | **Lambda hace polling** del servicio y lo invoca con lotes (batches) | Depende del origen (ver más abajo) |

### Invocación síncrona: ALB + Lambda

Para exponer una Lambda a través de un **ALB**, se **registra la función en un target group**. Cuando llega un request
por HTTPS, el ALB lo convierte en un **JSON** y se lo envía a la Lambda.

- La Lambda responde también en **JSON** y el ALB lo convierte en una respuesta **HTTP**.
- Tanto en el request como en la respuesta, los **headers** van como pares key/value dentro del JSON.
- El **body** se puede enviar en **base64**, indicándolo con el campo **`isBase64Encoded`** (`true` o `false`).
- Si se habilitan los **multi-value headers** en el **target group**, la Lambda recibe y devuelve `multiValueHeaders`
  en lugar de `headers`. Según el curso, los query params con varios valores para el mismo atributo llegan como un
  **arreglo**.

### Invocación asíncrona

La usan servicios como **S3**, **SNS** y **EventBridge**. Lambda procesa el evento y, si hay un error, lo
**reintenta**.

- Por defecto reintenta **2 veces** y retiene el evento hasta **6 horas**.
- Como puede haber reintentos, **pueden aparecer duplicados**: la función tiene que estar preparada para eso
  (idempotencia).
- Si el error persiste se puede definir una **DLQ (dead-letter queue)** en **SQS** o **SNS** para procesar los eventos
  fallidos.

**EventBridge (CloudWatch Events) + Lambda**: se puede definir un **cron** para invocar una Lambda cada cierto
tiempo, o usar un evento de otro servicio (por ejemplo, de **CodePipeline**) como disparador.

**S3 Event Notifications + Lambda**: S3 puede notificar eventos de objetos creados, eliminados, restaurados y
replicados. Pueden ir a **SNS**, **SQS** o directo a **Lambda**.

- Directo a Lambda es un proceso **asíncrono** y puede tardar **segundos o incluso un minuto o más**.
- Conviene **activar el versionado** del bucket: si dos escrituras sobre un mismo objeto sin versionado ocurren a la
  vez, puede enviarse **una sola** notificación. Con versionado se envía una por cada escritura exitosa.

### Event Source Mapping

Es un tercer tipo de proceso, distinto del síncrono y del asíncrono. Acá **Lambda hace polling** del servicio de
origen: **Kinesis Data Streams**, **SQS**, **SQS FIFO** y **DynamoDB Streams**.

**Streams (Kinesis y DynamoDB Streams)**:

- Se crea un **iterador por cada shard** del stream y los registros se consumen **en orden**. Según el curso, se pueden
  procesar hasta **10 batches en paralelo por shard**.
- Si hay un **error**, se **reprocesa todo el batch** hasta que funcione o hasta que los registros **expiren**. Un
  batch con error puede **bloquear** el procesamiento.
- Para evitarlo se puede **limitar la cantidad de reintentos**, **descartar los registros viejos** y, según el curso,
  **dividir el batch** que falla (para no chocar con el timeout de la Lambda).
- Los registros descartados pueden enviarse a un **destino**, como una cola **SQS**.

**SQS y SQS FIFO**:

- Se configura el **batch size** y se puede usar **long polling**.
- Lambda invoca la función de forma **sincrónica**, por eso la **DLQ se configura en la cola SQS de origen** (con su
  redrive policy), **no en la Lambda**. AWS recomienda un `maxReceiveCount` de al menos 5.

> 📝 **Nota del examen**: la DLQ **de la función** y los **destinations** sirven para invocaciones **asíncronas**. Con
> **SQS como origen**, la DLQ va en la **cola**.

### Lambda Destinations

Permiten enviar el resultado de las invocaciones **asíncronas** a un destino, separando los eventos **exitosos**
(on-success) de los **fallidos** (on-failure).

- Destinos posibles: **SQS**, **SNS**, **otra Lambda** y un **bus de EventBridge**.
- Un **bucket de S3** también se soporta, pero **solo para fallas**.
- Se pueden usar **además de** una DLQ o **en lugar de** ella.

### Variables de entorno

Lambda permite definir **variables de entorno** como pares **key/value**. Se **encriptan siempre en reposo** con KMS:
por defecto con una key administrada por AWS, y también se puede usar una key propia.

### Monitoreo y X-Ray

- Lambda publica **métricas en CloudWatch** sin costo adicional. Por ejemplo, `Invocations` (veces que se ejecutó el
  código, sin contar las invocaciones rechazadas por throttling) y `Errors` (excepciones del código y errores del
  runtime, como los timeouts). La tasa de error se calcula como `Errors / Invocations`.
- Los **logs** de la función van a **CloudWatch Logs**: la execution role de la función necesita permisos para
  escribirlos.
- **CloudWatch Lambda Insights** agrega métricas a nivel de sistema: CPU, memoria, disco y red.
- **X-Ray**: se habilita el **tracing activo** en la configuración de la función y Lambda crea los segmentos de traza
  automáticamente. Hay dos modos: **Active** y **PassThrough** (solo propaga el contexto de trazado a los servicios
  siguientes, sin crear segmentos). La función necesita permisos de IAM para enviar las trazas. No hace falta instalar
  el daemon (ver la sección de X-Ray).

### Lambda@Edge y CloudFront Functions

Las dos permiten **ejecutar código en respuesta a eventos de CloudFront**, para personalizar requests y respuestas
cerca del usuario.

| Característica | CloudFront Functions | Lambda@Edge |
| :--- | :--- | :--- |
| Runtime | JavaScript | Node.js o Python |
| Eventos de CloudFront | Solo los de **viewer** (viewer request y viewer response) | Los **cuatro**: viewer request, viewer response, origin request y origin response |
| Rendimiento | Arranque en **menos de un milisegundo**, escala a millones de requests por segundo | Funciones de Lambda completas, con más capacidad y más latencia |
| Despliegue | Feature nativa de CloudFront: se crea, prueba y despliega dentro de CloudFront | Se publica en **una sola región** y CloudFront la replica a los edge locations |
| Uso típico | Cambios livianos: reescribir URLs, manipular headers, validaciones simples | Lógica más pesada o que necesita las capacidades completas de Lambda |

- **Viewer request**: cuando CloudFront recibe el request del usuario, antes de consultar el cache.
- **Origin request**: solo en un **cache miss**, justo antes de enviar el request al origen.
- **Origin response**: cuando el origen responde, antes de guardar el objeto en el cache.
- **Viewer response**: antes de enviar la respuesta al usuario.
- Cada **cache behavior** puede tener hasta **cuatro triggers** de Lambda@Edge.

### Lambda en una VPC

- Por defecto, la función corre en una **VPC administrada por Lambda**, con acceso a internet pero **sin acceso a los
  recursos privados** de tu VPC (RDS, ElastiCache, instancias EC2 internas).
- Para llegar a esos recursos se **asocia la función a tu VPC**, indicando **subnets privadas** y **security groups**.
- Una vez asociada, la función **pierde el acceso a internet**, salvo que haya una ruta: un **NAT Gateway** en una
  subnet pública, con la route table de la subnet privada apuntando a él. Para llegar a servicios de AWS sin pasar por
  internet se pueden usar **VPC endpoints**.
- Si muchas funciones Lambda se conectan a una base de datos relacional, conviene **RDS Proxy** (ver la sección de
  RDS).

### Rendimiento de la función

- **Memoria**: de **128 MB a 10.240 MB**, en incrementos de 1 MB. No se configura la CPU directamente: la CPU
  **escala en proporción a la memoria**, y a **1.769 MB** la función tiene el equivalente a **un vCPU**.
- **Timeout**: **3 segundos por defecto**, hasta un máximo de **900 segundos**.
- **Almacenamiento efímero (`/tmp`)**: de **512 MB a 10.240 MB**, encriptado en reposo. Se **comparte entre las
  invocaciones** que atiende el mismo execution environment, así que sirve para cachear archivos.
- **Cold start**: cuando Lambda crea un nuevo execution environment, descarga el código, inicializa el runtime y ejecuta
  el código de inicialización antes de atender el request.
- **Código de inicialización**: lo que se define **fuera del handler** (clientes del SDK, conexiones) se ejecuta una vez
  por execution environment y se **reutiliza** en las invocaciones siguientes.
- Como se paga por **duración y memoria**, subir la memoria puede acortar el tiempo de ejecución y no encarecer la
  función. Conviene medir distintos tamaños.

### Lambda Layers

Una **layer** es un paquete con código o dependencias que se **comparte entre funciones**.

- Una función admite hasta **5 layers**.
- El tamaño total **descomprimido** de la función más todas sus layers no puede superar **250 MB**.
- Las layers se extraen en el directorio **`/opt`** del execution environment.
- Sirven para **librerías compartidas**, dependencias pesadas y **custom runtimes**.
- Para actualizar una librería se publica una **nueva versión de la layer** y se actualiza la referencia en las
  funciones.

### Montar un file system (EFS)

Una función puede **montar un file system de Amazon EFS** para compartir datos entre invocaciones, leer archivos de
referencia grandes o escribir resultados en un almacenamiento persistente.

- La función tiene que estar **asociada a una VPC**, porque los mount targets de EFS son recursos de la VPC.
- Se necesita un **mount target de EFS en cada AZ** a la que se conecta la función. Para mayor resiliencia conviene usar
  **al menos dos AZ**.
- La función accede a través de un **EFS access point**, y su execution role necesita el permiso
  `elasticfilesystem:ClientMount` (y `elasticfilesystem:ClientWrite` para escribir).
- No hay cargo adicional por usar file systems desde una función dentro de la misma VPC.

> 📝 **Novedad**: la documentación actual también incluye una opción de montaje con **Amazon S3 Files**.

### Concurrency

La **concurrencia** es la cantidad de ejecuciones de la función que ocurren a la vez.

- Por defecto, cada cuenta tiene un límite de **1.000 ejecuciones concurrentes por región**, compartido por todas las
  funciones. Se puede pedir un aumento.
- **Reserved concurrency**: se **reserva** una cantidad de concurrencia para una función. Le **garantiza** esa capacidad
  y a la vez le pone un **tope**. AWS exige dejar al menos 100 sin reservar para el resto de las funciones.
- **Provisioned concurrency**: Lambda mantiene **execution environments ya inicializados**, listos para responder. Evita
  los **cold starts** y se cobra aparte.
- **Throttling**: si se supera el límite, las invocaciones **síncronas** reciben un error **429
  (`TooManyRequestsException`)**. Las **asíncronas** se reintentan, y el evento se retiene hasta 6 horas.
- Lambda puede crear **1.000 execution environments cada 10 segundos** para absorber un pico.

### Dependencias externas

Si la función usa librerías que no vienen incluidas en el runtime, hay que **incluirlas en el deployment package** (un
`.zip`) junto con el código. Por ejemplo, la carpeta `node_modules` en Node.js o los paquetes instalados en un
directorio local en Python.

- Un `.zip` se puede subir **directo hasta 50 MB**. Si es más grande, se sube a **S3** y se referencia desde ahí.
- El tamaño **descomprimido** (código más layers) no puede superar **250 MB**.
- Alternativas cuando el paquete es muy grande: **layers** o **container images** (hasta 10 GB).

### Lambda y CloudFormation

- **Código inline**: en un template de CloudFormation, el código se puede escribir **directamente en la propiedad
  `ZipFile`**, pero solo para funciones de **Node.js y Python**.
- **Código en S3**: para el resto, el deployment package se referencia con `S3Bucket`, `S3Key` y, opcionalmente,
  `S3ObjectVersion`.
- Si se sube código nuevo a S3 con **la misma key**, CloudFormation **no detecta el cambio**, porque el template no
  cambió. Hay que modificar `S3Key` o `S3ObjectVersion` para que actualice la función.
- Al actualizar una función, CloudFormation llama primero a `UpdateFunctionConfiguration` y después a
  `UpdateFunctionCode`. Entre esas dos llamadas puede haber invocaciones con errores.

### Container Images

Una función Lambda también se puede empaquetar como **imagen de contenedor**, hasta **10 GB**.

- La imagen se guarda en **Amazon ECR**, en la **misma región** que la función (puede ser de otra cuenta).
- Hay tres puntos de partida: una **imagen base de AWS** para un lenguaje, una **imagen base OS-only** (Amazon Linux más
  el runtime interface emulator, típica para Go, Rust o versiones de lenguaje sin imagen base) o una **imagen propia**.
- Cualquier imagen debe **implementar la Lambda Runtime API**: las imágenes de AWS ya incluyen el **runtime interface
  client**, y en una imagen propia hay que agregarlo.
- Se puede probar localmente con el **runtime interface emulator**.

### Versions y Aliases

- **`$LATEST`** es la versión editable de la función.
- Al **publicar** una versión se crea una **versión inmutable**: una foto del código y la configuración en ese momento.
- Un **alias** es un **puntero con nombre** a una versión (por ejemplo `prod` o `dev`) y se puede **reasignar** a otra
  versión. Los triggers conviene apuntarlos al **ARN del alias**, así no hay que tocarlos al desplegar una versión
  nueva.
- Un alias puede repartir el tráfico entre **dos versiones con pesos**: es un **weighted alias**, base de los
  **canary deployments**. Permite probar una versión nueva con poco tráfico y **volver atrás rápido** si falla.

### Lambda y CodeDeploy

**CodeDeploy** automatiza el cambio gradual de tráfico entre dos versiones de una función, usando un alias. SAM lo trae
integrado.

- **Canary**: se envía un porcentaje pequeño del tráfico a la versión nueva y, pasado un tiempo, el resto. Por ejemplo,
  `Canary10Percent5Minutes`: 10% primero y el 90% restante cinco minutos después.
- **Linear**: el tráfico se mueve de a incrementos iguales. Por ejemplo, `Linear10PercentEvery1Minute`.
- **All at once**: todo el tráfico pasa de inmediato a la versión nueva.
- **Hooks**: funciones que **validan** el deployment, antes (`BeforeAllowTraffic`) y después (`AfterAllowTraffic`) de
  mover el tráfico.
- Si un hook falla o se dispara una **alarma de CloudWatch**, CodeDeploy hace **rollback** automático.

### Function URL

Una **function URL** es un **endpoint HTTPS dedicado** para invocar la función **sin pasar por API Gateway**. Tiene el
formato `https://<url-id>.lambda-url.<región>.on.aws` y no tiene costo adicional.

- **Auth type `AWS_IAM`**: solo pueden invocarla usuarios o roles autenticados, con requests firmados (SigV4).
- **Auth type `NONE`**: endpoint **público**, que se puede invocar con un navegador o `curl`. La **resource-based
  policy** de la función siempre se aplica y tiene que otorgar acceso público para que reciba requests.
- Soporta **configuración de CORS**.

> 📝 **Cuándo usarla**: es la forma más simple de exponer una función por HTTPS. Si hacen falta funciones propias de
> API Gateway (API keys, usage plans, caché), se usa API Gateway.

### Límites (Limits)

| Recurso | Límite |
| :--- | :--- |
| Memoria | 128 MB a 10.240 MB |
| Timeout | 900 segundos (15 minutos) |
| Almacenamiento efímero (`/tmp`) | 512 MB a 10.240 MB |
| Concurrencia por región | 1.000 por defecto (se puede aumentar) |
| Payload de invocación síncrona | 6 MB (request y respuesta) |
| Payload de invocación asíncrona | 1 MB |
| Deployment package (`.zip`) | 50 MB subido directo, 250 MB descomprimido (incluye layers) |
| Container image | 10 GB |
| Layers por función | 5 |
| Variables de entorno | 4 KB en total |

> 📝 **Nota**: el límite de 15 minutos aplica a las funciones estándar. Algunos modelos nuevos (como Lambda Managed
> Instances) permiten más tiempo en ciertos tipos de invocación.

### Buenas prácticas

- **Inicializar** clientes del SDK y conexiones a bases de datos **fuera del handler**, y **cachear archivos estáticos
  en `/tmp`**: las invocaciones siguientes en el mismo execution environment los reutilizan y se reduce el tiempo de
  ejecución.
- Usar **variables de entorno** para pasar parámetros operativos, en lugar de escribirlos en el código.
- **Minimizar el tamaño del deployment package**, para acortar los cold starts.
- **Evitar el código recursivo**, que puede disparar invocaciones en cadena sin control.
- Conectar muchas funciones a una base relacional mediante **RDS Proxy**.

## Amazon DynamoDB

> 🔗 **Documentación oficial**: [Amazon DynamoDB Developer Guide](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Introduction.html)

**DynamoDB** es una base de datos **NoSQL administrada, serverless y de baja latencia**. Escala a millones de requests
por segundo y no hay servidores que administrar. Es una de las bases más importantes del examen.

### Conceptos básicos

- Una **tabla** contiene **items** (las filas) y cada item tiene **atributos** (las columnas). Salvo la primary key, no
  hay un esquema fijo: cada item puede tener atributos distintos.
- **Tamaño máximo de un item: 400 KB**, contando nombres y valores de los atributos.
- **Primary key** (se define al crear la tabla):
  - **Solo partition key**: tiene que ser **única** para cada item.
  - **Partition key + sort key** (clave compuesta): la combinación debe ser única, y los items con la misma partition
    key se guardan juntos, ordenados por la sort key.
- Conviene elegir una partition key con **alta cardinalidad** (muchos valores distintos) para repartir bien la carga.
- **Tipos de datos**: escalares (`String`, `Number`, `Binary`, `Boolean`, `Null`), de documento (`List` y `Map`) y sets
  (`String Set`, `Number Set`, `Binary Set`).
- **Table classes**: **Standard** (por defecto) y **Standard-Infrequent Access**, más barata para almacenar datos que
  se acceden poco.

### Capacity modes

| Modo | Cómo funciona | Cuándo conviene |
| :--- | :--- | :--- |
| **Provisioned** | Se define la cantidad de **RCU y WCU** por segundo y se paga por la capacidad reservada. Se puede combinar con **auto scaling** | Tráfico estable y predecible |
| **On-demand** | No hay que planificar capacidad: DynamoDB **escala solo** y se paga **por request** (más caro por unidad) | Tráfico impredecible, tablas nuevas o con picos |

- Se puede **cambiar de modo**, con un límite de una vez cada 24 horas. El cambio puede tardar unos minutos.
- En provisioned, si se supera la capacidad hay **throttling**.

### WCU y RCU

- **WCU (Write Capacity Unit)**: una escritura por segundo de un item de hasta **1 KB**.
- **RCU (Read Capacity Unit)**: una lectura **strongly consistent** por segundo de un item de hasta **4 KB**, o **dos**
  lecturas **eventually consistent**.
- Un **transactional read** consume **2 RCU** por cada 4 KB, y una **transactional write** consume **2 WCU** por cada
  1 KB.
- El tamaño del item se **redondea hacia arriba** al múltiplo de 1 KB (escrituras) o de 4 KB (lecturas).

| Tipo de lectura | RCU por cada 4 KB |
| :--- | :--- |
| Eventually consistent | 0,5 |
| Strongly consistent | 1 |
| Transactional | 2 |

**Ejemplos de cálculo**:

- **10 escrituras por segundo de items de 2 KB**: cada item usa 2 WCU, así que se necesitan **20 WCU**.
- **16 lecturas strongly consistent por segundo de items de 12 KB**: cada item usa 3 RCU, así que se necesitan **48
  RCU**. Con eventually consistent serían 24 RCU, y con transactional, 96 RCU.
- **Un item de 6 KB** se redondea a 8 KB: una lectura strongly consistent usa **2 RCU**.

> 📝 **Nota del examen**: por defecto, `GetItem`, `Query` y `Scan` hacen lecturas **eventually consistent**. Para una
> lectura strongly consistent se manda el parámetro **`ConsistentRead = true`**, que consume el doble de RCU.

### Throttling y particiones

- Los datos se reparten en **particiones** según la partition key. Cada partición soporta como máximo **3.000 RCU y
  1.000 WCU por segundo**, sin importar la capacidad total de la tabla.
- Una **hot partition** (o hot key) ocurre cuando una partition key recibe mucho más tráfico que las demás: genera
  throttling aunque la tabla tenga capacidad sobrante.
- El error de throttling es **`ProvisionedThroughputExceededException`**. Las causas típicas son una hot key, una
  lectura muy grande o capacidad insuficiente.
- **Soluciones**:
  - **Exponential backoff**: reintentar con esperas crecientes. Los SDK de AWS ya lo implementan por defecto.
  - **Elegir mejor la partition key** (alta cardinalidad) y **distribuir los requests**.
  - **Write sharding**: agregar un **sufijo aleatorio** a la partition key (por ejemplo `POST#123#1` a `POST#123#200`)
    para repartir las escrituras de una key muy popular en varias particiones.
  - **DAX** para aliviar lecturas repetidas sobre las mismas keys.
- DynamoDB tiene **burst capacity** y **adaptive capacity**, que absorben picos y redistribuyen capacidad hacia las
  particiones calientes, pero no reemplazan un buen diseño de claves.

### Operaciones básicas

**Escritura**:

- **`PutItem`**: crea un item o **reemplaza uno existente** completo.
- **`UpdateItem`**: modifica **atributos puntuales** de un item (o lo crea si no existe). Permite también **atomic
  counters** (incrementos atómicos).
- **`DeleteItem`**: borra un item. **`DeleteTable`** borra toda la tabla.
- Todas admiten **conditional writes** (ver más abajo).

**Lectura**:

- **`GetItem`**: lee un item por su primary key. Con **`ProjectionExpression`** se piden solo ciertos atributos.
- **`Query`**: devuelve los items de **una partition key**, opcionalmente filtrados por una condición sobre la sort key
  (`KeyConditionExpression`). Es **eficiente** y puede consultar también un índice.
- **`Scan`**: **lee toda la tabla** (o un índice) y recién después filtra. Es **ineficiente y caro**, porque consume
  RCU por todos los items leídos, aunque el filtro los descarte. Para acelerarlo se usa un **parallel scan**.
- **`FilterExpression`** (en `Query` y `Scan`) se aplica **después de leer los datos**: **no reduce el consumo de RCU**.
- Cada llamada devuelve hasta **1 MB** de datos. Si hay más, la respuesta incluye **`LastEvaluatedKey`**, que se manda
  como **`ExclusiveStartKey`** en la llamada siguiente (paginación). El parámetro **`Limit`** acota la cantidad de
  items.

**Operaciones en lote (batch)**:

- **`BatchGetItem`**: hasta **100 items** (16 MB) de una o más tablas.
- **`BatchWriteItem`**: hasta **25 `PutItem` o `DeleteItem`** (16 MB). **No** soporta `UpdateItem`.
- Cada item del batch tiene éxito o falla por separado. Los que no se procesaron vuelven en **`UnprocessedItems`** o
  **`UnprocessedKeys`** y hay que **reintentarlos** con backoff.

### AWS CLI con DynamoDB

```bash
aws dynamodb query \
  --table-name Orders \
  --key-condition-expression "customerId = :c" \
  --expression-attribute-values '{":c": {"S": "user-1"}}' \
  --projection-expression "orderId, total" \
  --max-items 10
```

- **`--projection-expression`**: qué atributos devolver.
- **`--filter-expression`**: filtro aplicado después de leer.
- **`--key-condition-expression`**: condición de la partition key (y opcionalmente la sort key).
- **`--page-size`**: cantidad de items que el CLI pide **en cada llamada a la API**. Es útil para evitar timeouts en
  tablas grandes.
- **`--max-items`**: cantidad **total** de items que devuelve el comando. Si hay más, entrega un **`NextToken`**.
- **`--starting-token`**: el `NextToken` anterior, para **continuar** desde donde quedó.

### Conditional writes, concurrencia y optimistic locking

- Un **conditional write** (`PutItem`, `UpdateItem` o `DeleteItem` con un **`ConditionExpression`**) solo se ejecuta si
  la condición se cumple. Si no, falla con **`ConditionalCheckFailedException`** y **no cambia nada**.
- Funciones útiles en las condiciones: `attribute_exists`, `attribute_not_exists`, `attribute_type`, `contains`,
  `begins_with`, `size`, además de los operadores de comparación, `IN` y `BETWEEN`.
- **Evitar sobrescribir** un item que ya existe: `PutItem` con `attribute_not_exists(partitionKey)`.
- **Atomic counter**: con `UpdateItem` se incrementa un número de forma atómica, por ejemplo `SET visits = visits +
  :inc`. Si dos clientes lo ejecutan a la vez, ambos incrementos se aplican.
- **Optimistic locking**: cada item tiene un **atributo de versión**. Al actualizar, se envía una condición que verifica
  que la versión **siga siendo la que se leyó**, y se incrementa. Si otro cliente modificó el item antes, la versión no
  coincide, la escritura falla y la aplicación debe volver a leer y reintentar. Sirve cuando los conflictos son poco
  frecuentes.

### Índices secundarios (GSI y LSI)

Por defecto solo se puede consultar por la primary key. Los índices permiten consultar por **otros atributos**.

| Característica | **LSI** (Local Secondary Index) | **GSI** (Global Secondary Index) |
| :--- | :--- | :--- |
| Partition key | La **misma** que la tabla | Una **distinta** a la de la tabla |
| Sort key | Una **distinta** | Opcional, distinta |
| Cantidad | Hasta **5** por tabla | Hasta **20** por tabla (cuota por defecto) |
| Cuándo se crea | **Solo al crear la tabla** | **En cualquier momento** |
| Consistencia de lectura | Eventually o **strongly** consistent | **Solo eventually** consistent |
| Capacidad | **Comparte** la capacidad de la tabla | Tiene su **propia** capacidad (RCU y WCU) |

- Cada índice define una **projection**: qué atributos copia (`KEYS_ONLY`, `INCLUDE` o `ALL`).
- Si un **GSI** no tiene suficiente capacidad de escritura, **las escrituras de la tabla base también reciben
  throttling**. Por eso el GSI debe tener WCU adecuados.
- Un LSI limita a **10 GB** el tamaño de una colección de items con la misma partition key.

### PartiQL

**PartiQL** es un lenguaje **compatible con SQL** para trabajar con DynamoDB: soporta `SELECT`, `INSERT`, `UPDATE` y
`DELETE`. Se usa desde la consola, el CLI o los SDK.

- Operaciones de la API: **`ExecuteStatement`**, **`BatchExecuteStatement`** y **`ExecuteTransaction`**.
- Un `SELECT` también pagina: devuelve hasta **1 MB** y un `LastEvaluatedKey` para continuar.
- Un `SELECT` sin condición sobre la primary key termina siendo un **scan** completo.

### DynamoDB Accelerator (DAX)

**DAX** es un **cache en memoria totalmente administrado** para DynamoDB. Baja la latencia de lectura de
**milisegundos a microsegundos**.

- Es **compatible con la API de DynamoDB**: no hay que cambiar la lógica de la aplicación, solo usar el cliente de DAX.
- Funciona como un **cluster** de nodos (un primario y réplicas) dentro de la VPC.
- Tiene un **item cache** y un **query cache**. El **TTL por defecto es de 5 minutos**.
- Opera en **modo write-through**: las escrituras van a DAX y a la tabla.
- Es ideal para **lecturas eventually consistent** y para cargas de lectura intensiva sobre las mismas keys (**hot
  keys**). Las lecturas strongly consistent y los cache miss van a DynamoDB.
- **DAX vs ElastiCache**: DAX acelera las **lecturas de DynamoDB** sin código adicional. ElastiCache sirve para
  guardar **resultados agregados o calculados** (por ejemplo, el resultado de un `Scan` o de una consulta compleja) y
  datos de cualquier origen.

### DynamoDB Streams

Un **stream** registra, en orden, **cada cambio** (creación, actualización y borrado) de los items de una tabla.

- Los registros se guardan durante **24 horas**.
- **Stream view types**, que definen qué se guarda en cada registro:
  - `KEYS_ONLY`: solo las claves del item modificado.
  - `NEW_IMAGE`: el item completo **después** del cambio.
  - `OLD_IMAGE`: el item completo **antes** del cambio.
  - `NEW_AND_OLD_IMAGES`: ambos.
- Se procesan con **Lambda** (mediante un event source mapping), con la **Kinesis Client Library** o con otras
  aplicaciones.
- Casos de uso: reaccionar a cambios en tiempo real, enviar notificaciones, **analítica**, insertar datos en
  **OpenSearch** y **replicación entre regiones** (global tables).
- Alternativa: enviar los cambios a **Kinesis Data Streams**, que conserva los datos **hasta 365 días** y permite
  varios consumers (por ejemplo, Firehose o Flink).

### Time to Live (TTL)

El **TTL** elimina automáticamente los items **vencidos**, sin consumir capacidad de escritura.

- Se elige un **atributo** de tipo **Number** con un timestamp en formato **Unix epoch (segundos)**.
- DynamoDB borra los items en segundo plano, **típicamente dentro de las 48 horas** posteriores al vencimiento y como
  máximo en unos pocos días. Mientras tanto, el item **puede seguir apareciendo** en las lecturas.
- Los borrados por TTL aparecen en **DynamoDB Streams**, lo que permite archivarlos o procesarlos.
- Casos de uso: **sesiones**, datos temporales, logs que no hace falta conservar, cumplimiento de políticas de
  retención.

### Transacciones

Las **transacciones** permiten **cambios coordinados "todo o nada"** sobre múltiples items, incluso en distintas
tablas, con propiedades **ACID**.

- **`TransactWriteItems`** y **`TransactGetItems`**.
- Hasta **100 items** distintos por transacción, con un tamaño total de hasta **4 MB**. Deben estar en la **misma
  cuenta y la misma región**.
- Dos acciones de la misma transacción **no pueden apuntar al mismo item**.
- Una acción `ConditionCheck` permite agregar condiciones sin modificar el item.
- Consumen el **doble de capacidad** (2 RCU o 2 WCU por unidad).
- Casos de uso: **transacciones financieras**, pedidos, reservas de stock, cualquier operación que no pueda quedar a
  medias.

### Casos de uso y patrones

- **Session state**: DynamoDB (con **TTL**) es una opción habitual para guardar el estado de sesión de las aplicaciones
  *stateless*. Ofrece persistencia y escala automática. **ElastiCache** es más rápido, pero no persiste los datos.
  **EFS o EBS** sirven si el estado es de un solo servidor o necesita un file system, y **S3** se usa para objetos
  grandes, no para sesiones.
- **Objetos grandes con S3**: DynamoDB limita los items a **400 KB**. Para archivos más grandes se guarda el archivo en
  **S3** y en DynamoDB se guarda la **metadata** y una **referencia** (el bucket y la key). También se usa DynamoDB para
  **indexar los objetos de S3** y poder buscarlos por metadata, algo que S3 no permite.
- **Operaciones de mantenimiento**: para **vaciar una tabla**, recorrerla con `Scan` y borrar item por item es lento y
  caro. Es mejor **borrar la tabla y volver a crearla**. Para **copiar una tabla** se puede usar **AWS Backup**,
  **exportar a S3** y **volver a importar**, o un trabajo que escanee y escriba.

### Backups y Global Tables

- **Backups on-demand**: copias completas que se conservan hasta que se borran, sin afectar el rendimiento. También se
  administran con **AWS Backup**.
- **Point-in-time recovery (PITR)**: backups continuos con **granularidad de un segundo**, hasta **35 días** atrás. La
  restauración **siempre crea una tabla nueva**.
- **Global Tables**: tablas **multi-región y multi-activas**, con **réplicas** en distintas regiones que aceptan
  lecturas y escrituras. Los cambios se propagan en general en **menos de un segundo**. Dan baja latencia a usuarios
  globales y **recuperación ante desastres**. Se apoyan en **DynamoDB Streams**.
- **DynamoDB Local**: versión para desarrollo y pruebas locales, sin conexión a AWS.

### Seguridad

- **Autorización con IAM**, incluso a nivel de **item y atributo** (**fine-grained access control**) con condiciones
  como `dynamodb:LeadingKeys`, que limita el acceso a items cuya partition key coincida con la identidad del usuario.
- **Encriptación en reposo** siempre activada, con **KMS**. **En tránsito**, con TLS (HTTPS).
- **VPC endpoint** (de tipo gateway) para acceder a DynamoDB **sin salir por internet**.
- **AWS DMS** permite migrar datos hacia DynamoDB desde otras bases (y a la inversa), incluso entre motores distintos.

## Amazon API Gateway

> 🔗 **Documentación oficial**: [Amazon API Gateway Developer Guide](https://docs.aws.amazon.com/apigateway/latest/developerguide/welcome.html)

**API Gateway** es un servicio administrado y serverless para **crear, publicar, proteger y monitorear APIs** a
cualquier escala. Funciona como la **puerta de entrada** de las aplicaciones: recibe las requests de los clientes y las
envía a un backend, que puede ser una **función Lambda**, un **endpoint HTTP** o una **acción de un servicio de AWS**.

Entre sus funciones se destacan el **manejo de versiones y de múltiples ambientes** (stages), la **autenticación y
autorización**, el **throttling**, la **validación de requests**, el **caché** y la **generación de SDKs y de
documentación**.

### Tipos de API

| Característica | **REST API** | **HTTP API** | **WebSocket API** |
| :--- | :--- | :--- | :--- |
| Qué es | La opción original, con **todas las funciones** | Versión más simple, **más barata** (alrededor de 70%) y con menor latencia | Conexiones **bidireccionales persistentes** para tiempo real |
| Autorización | IAM, Cognito User Pools, Lambda authorizer | IAM, Lambda authorizer, **JWT authorizer** nativo | IAM, Lambda authorizer (en `$connect`) |
| Caché, usage plans y API keys | **Sí** | **No** | No |
| Validación de requests, WAF | **Sí** | No | No |
| Mapping templates (transformaciones) | **Sí** | Limitadas | Sí |
| CORS | Se configura por recurso | **Configuración simple** y automática | No aplica |

> 📝 **Nota del examen**: si una pregunta pide **API keys, usage plans, caché o transformaciones de request**, la
> respuesta es **REST API**. Si pide **menor costo y menor latencia** con un proxy simple, **HTTP API**. Si pide
> **comunicación bidireccional en tiempo real** (chat, notificaciones), **WebSocket API**.

### Tipos de endpoint

- **Edge-optimized** (por defecto en las REST APIs): las requests entran por el **punto de presencia de CloudFront** más
  cercano. Es lo mejor para clientes **distribuidos geográficamente**.
- **Regional**: pensado para clientes en la **misma región** de la API.
- **Private**: solo se accede **desde una VPC**, mediante un VPC endpoint de interfaz.

**Custom domain names**: se usa un dominio propio con un certificado de **ACM**. Para un endpoint **edge-optimized** el
certificado debe estar en **us-east-1**, y para uno **regional** debe estar en la **misma región** de la API. Luego se
crea un **alias record en Route 53** hacia el dominio de API Gateway.

### Tipos de integración

| Tipo | Descripción |
| :--- | :--- |
| **`AWS_PROXY`** (Lambda proxy) | La request completa llega a la Lambda como evento y la **Lambda arma la respuesta**. Es la más simple y la más usada |
| **`AWS`** (custom) | Integración con una función Lambda **o cualquier servicio de AWS**, con **mapping templates** para transformar request y respuesta |
| **`HTTP_PROXY`** | Pasa la request y la respuesta **sin cambios** a un endpoint HTTP |
| **`HTTP`** | Integración con un endpoint HTTP con **mapping templates** |
| **`MOCK`** | API Gateway responde **sin llamar a ningún backend**, útil para pruebas o para el preflight de CORS |

- Con **Lambda proxy**, la función debe devolver un JSON con `statusCode`, `headers` y `body`. Si el formato es
  incorrecto, API Gateway devuelve **502 (Bad Gateway)**.
- **Mapping templates**: usan el lenguaje **VTL (Velocity Template Language)** y solo aplican en las integraciones
  **no proxy**. Permiten **renombrar o agregar parámetros**, modificar el body o los headers, **filtrar** campos de la
  respuesta o convertir formatos (por ejemplo, **XML a JSON**).
- **VPC Link**: permite que API Gateway llegue a recursos **privados dentro de una VPC** (por ejemplo, un NLB interno).

### Stages y deployments

- Un cambio en la API **no se aplica hasta que se hace un deployment**. Un **deployment** es una **foto** de la API.
- Un **stage** es una **referencia con nombre a un deployment** (por ejemplo `dev`, `test`, `prod`). Cada stage tiene su
  propia **URL**, y se pueden configurar caché, throttling, logging y variables.
- **Stage variables**: pares clave-valor que actúan como **variables de entorno** de la API. Se usan, por ejemplo, para
  apuntar cada stage a un **alias distinto de una Lambda** o a otro endpoint HTTP, y en los mapping templates.
- Para hacer **rollback** basta con que el stage apunte de nuevo a un deployment anterior.

### Canary deployments

Un **canary release** separa el tráfico de un stage en dos: una porción **pequeña** va a la **versión nueva** (canary) y
el resto sigue en la versión de **producción**, según una **proporción configurable**.

- Se pueden **monitorear los logs y las métricas del canary** por separado.
- Cuando la nueva versión funciona bien, se **promueve** el canary a producción y la proporción vuelve a cero.
- El stage guarda el deployment base y el canary guarda el deployment nuevo.

### Caché de la API

- El caché es **por stage** y solo existe en las **REST APIs**. Guarda las respuestas del backend para **reducir la
  latencia y la carga** sobre el backend.
- **TTL por defecto: 300 segundos**, con un máximo de **3.600**. Un TTL de **0** desactiva el caché.
- Se puede **sobrescribir** la configuración **por método**, y **invalidar** el caché completo.
- Un cliente puede **saltearse el caché** con el header `Cache-Control: max-age=0`, siempre que tenga el **permiso de
  IAM** correspondiente.
- El caché tiene un **costo por hora** según su tamaño.

### Usage plans, API keys y throttling

- Un **usage plan** define **quién puede acceder** a qué stages y **cuánto**: un **límite de rate y burst**
  (throttling) y una **cuota** (requests por día, semana o mes).
- Las **API keys** identifican a los clientes y se **asocian a un usage plan**. El cliente las envía en el header
  **`x-api-key`**.
- Las API keys **no sirven para autenticar ni autorizar**: para eso se usan IAM, Cognito o un Lambda authorizer.
- **Límites de throttling por defecto**: **10.000 requests por segundo** por cuenta y región, con un **burst de 5.000**.
  Además se puede limitar por stage y por método.
- Al superar el límite, API Gateway responde **429 Too Many Requests**.

### Seguridad: autenticación y autorización

| Mecanismo | Cómo funciona | Cuándo usarlo |
| :--- | :--- | :--- |
| **IAM** (SigV4) | El cliente firma la request con credenciales de AWS y se valida con **políticas de IAM** | Usuarios y roles de AWS, otros servicios, acceso entre cuentas |
| **Cognito User Pools authorizer** | API Gateway **valida el token JWT** de Cognito, sin código propio | Aplicaciones web y móviles con usuarios en Cognito |
| **Lambda authorizer** (custom) | Una Lambda recibe el token o la request y **devuelve una política de IAM** | Tokens de terceros (OAuth, SAML) o lógica propia |
| **JWT authorizer** (solo HTTP API) | Valida tokens **OIDC / OAuth 2.0** de forma nativa | HTTP APIs |

- El Lambda authorizer puede ser de tipo **TOKEN** (recibe un token en un header) o **REQUEST** (recibe headers, query
  strings y contexto).
- Los resultados del authorizer se pueden **cachear**: TTL por defecto de **300 segundos**, máximo de **3.600**, y **0**
  lo desactiva. Con caché activo, la política devuelta se aplica a las requests siguientes del mismo token.
- **Resource policies**: documentos JSON asociados a la API, que permiten, por ejemplo, **acceso entre cuentas** o
  **restringir por IP o por VPC**.
- Las REST APIs se integran con **AWS WAF** para filtrar tráfico malicioso.

### CORS

Para que un navegador llame a la API desde otro origen hay que habilitar **CORS** (ver la sección de S3 CORS).

- El navegador envía antes una request **preflight `OPTIONS`**. La API debe responder con los headers
  `Access-Control-Allow-Origin`, `Access-Control-Allow-Methods` y `Access-Control-Allow-Headers`.
- En una **REST API** se habilita CORS **en cada recurso** (API Gateway crea el método `OPTIONS`). Con **Lambda
  proxy**, además, **la función debe devolver los headers CORS** en la respuesta.
- En una **HTTP API**, al configurar CORS API Gateway responde **automáticamente** el preflight.
- Si la Lambda falla o supera el timeout, API Gateway genera una respuesta 5xx **sin headers CORS**, y el navegador lo
  muestra como un **error de CORS** que oculta el problema real del backend.

### Monitoreo, logs y tracing

- **Execution logging**: registra lo que hace API Gateway para procesar cada request (errores, trazas, parámetros,
  datos del authorizer, uso de API keys).
- **Access logging**: registra **quién accedió** a la API y cómo, con el formato que se elija.
- Ambos van a **CloudWatch Logs** y se habilitan **por stage**. Requieren que la cuenta tenga un **rol de IAM** que le
  permita a API Gateway escribir en CloudWatch.
- **Métricas de CloudWatch**: `Count` (total de requests), `Latency` (tiempo total desde que API Gateway recibe la
  request hasta que responde), `IntegrationLatency` (tiempo del backend), `4XXError`, `5XXError`, `CacheHitCount` y
  `CacheMissCount`.
- **X-Ray**: se puede habilitar el tracing en el stage para ver el recorrido completo de cada request.

**Errores frecuentes**:

- **400**: request inválida o que **no pasó la validación**.
- **403**: acceso denegado (authorizer, resource policy, WAF o API key inválida).
- **429**: **throttling**.
- **502 (Bad Gateway)**: respuesta del backend con **formato inválido** (por ejemplo, una Lambda proxy mal armada).
- **503**: servicio no disponible.
- **504 (Gateway Timeout)**: el backend tardó más que el **timeout de integración**, que por defecto es de **29
  segundos** en las REST APIs (se puede pedir un aumento por Service Quotas).

### OpenAPI y validación de requests

- API Gateway permite **importar y exportar** definiciones de API en formato **OpenAPI 3.0 / Swagger 2.0**, con
  **extensiones propias** (`x-amazon-apigateway-*`) para las integraciones, los authorizers y los validators.
- Tras importar una API con Lambda en otra cuenta o región, hay que **volver a otorgar el permiso** de invocación sobre
  la función (se vuelve a seleccionar la Lambda en la integración).
- La **validación de requests** rechaza con un **400** las requests que no cumplan el **modelo (JSON Schema)** o los
  parámetros requeridos, **antes de llegar al backend**, lo que ahorra invocaciones y costos.

### WebSocket API

Una **WebSocket API** mantiene una **conexión persistente y bidireccional**: el cliente envía mensajes al servicio y el
servicio puede enviar mensajes al cliente **por su cuenta**. Se usa en **chats**, dashboards en tiempo real, juegos y
notificaciones.

- Rutas predefinidas: **`$connect`** (al abrir la conexión), **`$disconnect`** (al cerrarla) y **`$default`** (para los
  mensajes que no coinciden con otra ruta). También se pueden definir **rutas propias**.
- **Route selection expression**: expresión que se evalúa sobre cada mensaje para **elegir la ruta**, por ejemplo
  `$request.body.action`. Si ninguna ruta coincide se usa `$default`.
- La **autorización** se configura **solo en `$connect`**: se valida al establecer la conexión.
- Para que el backend **envíe un mensaje a un cliente conectado** se usan los comandos de **`@connections`**: un `POST`
  a la **connection URL** (`.../@connections/{connectionId}`) envía un mensaje, un `GET` devuelve información de la
  conexión y un `DELETE` desconecta al cliente. Hay que guardar los **connection ID**, por ejemplo en **DynamoDB**.

### Arquitectura típica

Un esquema serverless habitual combina varios servicios:

1. El cliente (web o móvil) llama a **API Gateway**, opcionalmente detrás de **CloudFront**.
2. **Cognito** (o un Lambda authorizer) autentica al usuario.
3. API Gateway invoca una **función Lambda**.
4. La Lambda lee y escribe en **DynamoDB** (con **DAX** o **ElastiCache** si hace falta acelerar las lecturas).
5. **CloudWatch** y **X-Ray** dan visibilidad de todo el recorrido.

Si el backend necesita procesamiento asíncrono, API Gateway puede integrarse directamente con **SQS**, **SNS**,
**Kinesis** o **Step Functions**, sin pasar por Lambda.

## AWS CI/CD (CodeCommit, CodePipeline, CodeBuild, CodeDeploy)

> 🔗 **Documentación oficial**: [AWS CodeCommit](https://docs.aws.amazon.com/codecommit/latest/userguide/welcome.html) ·
> [AWS CodePipeline](https://docs.aws.amazon.com/codepipeline/latest/userguide/welcome.html) ·
> [AWS CodeBuild](https://docs.aws.amazon.com/codebuild/latest/userguide/welcome.html) ·
> [AWS CodeDeploy](https://docs.aws.amazon.com/codedeploy/latest/userguide/welcome.html) ·
> [AWS CodeArtifact](https://docs.aws.amazon.com/codeartifact/latest/ug/welcome.html)

### Introducción a CI/CD en AWS

- **CI (Continuous Integration)**: los desarrolladores **suben el código con frecuencia** a un repositorio, y cada
  cambio dispara una **compilación y pruebas automáticas**. Detecta errores temprano.
- **Continuous Delivery**: el código validado queda **listo para desplegarse**, y el despliegue a producción requiere un
  **paso manual** (por ejemplo, una aprobación).
- **Continuous Deployment**: cada cambio que pasa las pruebas se **despliega automáticamente** a producción.

El flujo completo en AWS combina varios servicios:

| Etapa | Servicio |
| :--- | :--- |
| **Código** (source) | **CodeCommit**, GitHub, Bitbucket o S3 |
| **Build y test** | **CodeBuild** (o Jenkins) |
| **Despliegue** | **CodeDeploy**, Elastic Beanstalk, CloudFormation, ECS |
| **Orquestación** de todo el flujo | **CodePipeline** |
| **Dependencias y paquetes** | **CodeArtifact** |

### CodeCommit

**CodeCommit** es un servicio de **repositorios Git privados y administrados**, que escala sin que haya que operar
servidores.

- **Autenticación**: con **claves SSH** o con **credenciales HTTPS** (se puede usar el helper de AWS CLI), y soporta
  **MFA**.
- **Autorización**: con **políticas de IAM**.
- **Encriptación**: **en reposo** automáticamente con **KMS**, y **en tránsito** por HTTPS o SSH.
- **Acceso entre cuentas**: no se comparten claves SSH ni credenciales. Se usa un **rol de IAM** y la API **STS
  `AssumeRole`**.
- **Notificaciones y triggers**: los eventos del repositorio (push, pull requests, comentarios) se pueden enviar a
  **SNS**, **Lambda** o **EventBridge**.

> 📝 **Novedad**: en julio de 2024 AWS cerró CodeCommit a clientes nuevos, pero en noviembre de 2025 anunció su
> **regreso a disponibilidad general**. Algunas páginas de la documentación todavía muestran el aviso anterior. En el
> examen, igual aparece como el servicio de repositorios Git de AWS.

### CodePipeline

**CodePipeline** es un servicio de **orquestación** que automatiza el flujo desde el código hasta el despliegue.

- Un **pipeline** es un conjunto ordenado de **stages**, y cada stage tiene una o más **actions**.
- Debe tener **al menos dos stages**, y **el primero tiene que ser el de source**. Los demás pueden ser de build, test,
  deploy, approval o invoke.
- Las actions de un stage pueden correr en **secuencia o en paralelo**.
- Cada action recibe **input artifacts** y produce **output artifacts**, que se guardan en un **bucket de S3**
  (artifact store), encriptado con KMS.
- Puede incluir una **manual approval action**, que frena el pipeline hasta que alguien apruebe.
- **Triggers**: el pipeline se dispara cuando hay un cambio en el repositorio (por ejemplo, mediante **EventBridge**), de
  forma programada o manualmente. Los pipelines **V2** permiten **filtrar** por branch, tag o pull request.
- Si un stage **falla**, el pipeline se detiene en ese punto. Los cambios de estado generan **eventos de
  EventBridge** que se pueden usar para **notificaciones**, y las llamadas a la API quedan en **CloudTrail**.
- El pipeline usa un **rol de servicio de IAM**: sus permisos deben cubrir todos los servicios que invoca.

### CodeBuild

**CodeBuild** es un servicio de **build administrado y serverless**: compila el código, ejecuta las pruebas y genera
artefactos. Se **escala automáticamente** y se paga **por el tiempo de build**.

- **Source**: CodeCommit, S3, GitHub, Bitbucket, y también desde CodePipeline.
- Las instrucciones se definen en un archivo **`buildspec.yml`**, que se ubica en la **raíz del código fuente** (o se
  define al crear el proyecto).
- **Build environments**: imágenes de Docker administradas por AWS (con distintos lenguajes y runtimes) o **imágenes
  propias**.
- Los **artefactos** de salida se suben a **S3**, encriptados con KMS.
- Los **logs** van a **CloudWatch Logs** (y opcionalmente a S3), y hay **métricas** de CloudWatch. Los cambios de estado
  del build generan **eventos de EventBridge**.
- Un build puede correr **dentro de una VPC**, para acceder a recursos privados (por ejemplo, una base de datos de
  pruebas).
- Para **depurar un build**, se puede **correr CodeBuild localmente**.

**Estructura del `buildspec.yml`**:

```yaml
version: 0.2
env:
  variables:
    ENVIRONMENT: "dev"
  parameter-store:
    DB_PASSWORD: /app/db/password
phases:
  install:
    commands:
      - echo "Instalando dependencias"
  pre_build:
    commands:
      - echo "Corriendo tests"
  build:
    commands:
      - echo "Compilando"
  post_build:
    commands:
      - echo "Build terminado"
artifacts:
  files:
    - '**/*'
cache:
  paths:
    - '/root/.m2/**/*'
```

- **`env`**: variables de entorno en texto plano (`variables`) o tomadas de **SSM Parameter Store**
  (`parameter-store`) o de **Secrets Manager** (`secrets-manager`).
- **`phases`**: `install` (instalar paquetes), `pre_build` (comandos previos, como el login a un registro o los tests),
  `build` (el build en sí) y `post_build` (tareas finales, como empaquetar o subir una imagen).
- **`artifacts`**: qué archivos se suben a S3 al terminar.
- **`cache`**: directorios que se guardan en S3 para **acelerar los builds** siguientes (por ejemplo, las dependencias).

### CodeDeploy

**CodeDeploy** automatiza el **despliegue de aplicaciones** a distintos destinos (compute platforms):

- **EC2 / servidores on-premises**: requieren que esté instalado el **CodeDeploy Agent**.
- **AWS Lambda**: cambia el tráfico entre versiones mediante un **alias** (ver la sección de Lambda).
- **Amazon ECS**: despliegues blue/green de servicios.

Conceptos clave:

- **Application**: el nombre lógico de lo que se despliega.
- **Deployment group**: el conjunto de destinos (instancias identificadas por **tags** o un **Auto Scaling Group**).
- **Revision**: la versión del código y el **AppSpec** que se despliega (en **S3** o en GitHub).
- **Deployment configuration**: define **cuántas instancias se actualizan a la vez**.

**El archivo `appspec.yml`** va en la **raíz** del código y le indica a CodeDeploy qué hacer. En EC2 incluye:

- **`files`**: qué archivos copiar y a qué destino.
- **`hooks`**: scripts que se ejecutan en distintos momentos del despliegue. El orden es: `ApplicationStop`,
  `DownloadBundle`, `BeforeInstall`, `Install`, `AfterInstall`, `ApplicationStart` y `ValidateService`.

```yaml
version: 0.0
os: linux
files:
  - source: /
    destination: /var/www/app
hooks:
  BeforeInstall:
    - location: scripts/stop_server.sh
  ApplicationStart:
    - location: scripts/start_server.sh
  ValidateService:
    - location: scripts/health_check.sh
      timeout: 60
```

- Si un script de un hook **termina con un código distinto de cero**, el despliegue falla y se puede disparar un
  **rollback**.
- **`ValidateService`** es el último hook y se usa para comprobar que la aplicación quedó funcionando.

**Tipos de despliegue en EC2 / on-premises**:

| Tipo | Cómo funciona |
| :--- | :--- |
| **In-place** | Se actualizan **las mismas instancias**, con la aplicación detenida en cada una mientras se despliega. Se controla con la deployment configuration |
| **Blue/Green** | Se lanzan **instancias nuevas** (con un Auto Scaling Group) con la versión nueva, y el **load balancer** pasa el tráfico a ellas. Las viejas se pueden terminar después. Requiere un **load balancer** |

**Deployment configurations (EC2)**: **`AllAtOnce`** (todas las instancias a la vez), **`HalfAtATime`** (la mitad),
**`OneAtATime`** (de a una) o una **configuración personalizada** que indica el mínimo de instancias sanas.

**Rollbacks**: CodeDeploy puede revertir **automáticamente** si el despliegue falla o si se activa una **alarma de
CloudWatch**, volviendo a la **última revisión estable**. También se puede **redesplegar** manualmente una versión
anterior.

### CodeDeploy con EC2 y Auto Scaling Group

- Las instancias deben tener instalado el **CodeDeploy Agent**, que **consulta el servicio por HTTPS** (no necesita
  puertos de entrada), descarga la revisión y ejecuta los hooks. Necesitan un **instance profile** con permisos para leer
  la revisión (por ejemplo, desde S3).
- Al asociar un **Auto Scaling Group** a un deployment group, CodeDeploy crea un **lifecycle hook** en el ASG: las
  instancias nuevas quedan en espera (`Pending:Wait`) hasta que CodeDeploy les despliega la **última revisión**. Así,
  las instancias que lanza el ASG al **escalar** siempre tienen la versión actual.
- En un **blue/green con ASG**, CodeDeploy crea un **ASG nuevo** (copia del original), despliega la versión nueva ahí,
  mueve el tráfico del **load balancer** y después puede terminar el ASG anterior.

### CodeArtifact

**CodeArtifact** es un **repositorio de artefactos y dependencias** administrado, para almacenar y compartir paquetes de
software de forma segura. Evita depender directamente de repositorios públicos como npm o Maven Central.

- Soporta los gestores de paquetes más usados: **Maven y Gradle, npm y yarn, pip y twine, NuGet**, entre otros.
- Se organiza en un **domain** (agrupa y comparte los repositorios, y centraliza la encriptación) y en **repositories**.
- **Upstream repositories**: un repositorio puede **encadenarse con otros**, y consultarlos cuando no tiene un paquete.
- **External connection**: conexión de un repositorio a uno **público** (npmjs, Maven Central, PyPI). Los paquetes se
  descargan la primera vez y quedan **guardados (cacheados)** en CodeArtifact. Los desarrolladores solo usan
  CodeArtifact.
- **Seguridad**: acceso mediante **IAM** (con políticas de recurso para acceso entre cuentas) y encriptación con
  **KMS**.
- **Autenticación**: el cliente (npm, pip, etc.) obtiene un **token de autorización** con `aws codeartifact login`, que
  vale como máximo **12 horas** y hay que renovar.
- Los eventos de CodeArtifact (por ejemplo, la publicación de una nueva versión de un paquete) llegan a **EventBridge**
  y pueden **disparar un pipeline**.
- Es la forma de que **CodeBuild** descargue dependencias de manera controlada.

---

## Progreso del Curso

✅ **Completado hasta la lección 261 de 448** - CI/CD
