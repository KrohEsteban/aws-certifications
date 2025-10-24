# Ultimate AWS Certified Developer Associate 2025 DVA-C02 - Stéphane Maarek

## IAM & AWS CLI

### Conceptos Básicos

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

- **Version**: Fecha del formato de política (normalmente "2012-10-17").
- **Id**: Un identificador opcional para la política
- **Statement**: Uno o más statements (requerido), son las descripciones de las políticas. Dentro del statement tenemos:
  - **Sid**: Cada statement tiene un ID identificador también
  - **Effect**: Lo que hace el statement - permitir o denegar (Allow o Deny)
  - **Principal**: A quién se aplica la política
  - **Action**: Lista de acciones que hace la política (ej: "s3:GetObject" para obtener un objeto de S3)
  - **Resource**: A qué servicios o recursos se aplica la política (ej: "arn:aws:s3:::mybucket/*")
  - **Condition**: Campo opcional que se puede agregar para condiciones específicas de cuándo comienza a aplicarse la
    política

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

## EC2 Fundamentals

---

## Progreso del Curso

✅ **Completado hasta la lección 31** - IAM & AWS CLI
