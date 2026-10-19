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

---

## Progreso del Curso

✅ **Completado hasta la lección 58** - AWS Fundamentals: ELB + ASG
