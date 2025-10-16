# Ultimate AWS Certified Developer Associate 2025 DVA-C02 - Stéphane Maarek

## IAM & AWS CLI

### Conceptos Básicos

**IAM** = Identity and Access Management

- **Root Account**: Cuenta principal que solo debería usarse para crear otras
  cuentas y no se debería compartir con nadie
- **Usuarios**: Cuentas individuales que creas para personas y estas las puedes
  agrupar en diferentes grupos para darles permisos a todos a la vez
- **Políticas**: Declaraciones que se hacen a personas, grupos o servicios y
  contienen permisos para que accedan a ciertos servicios
- **Principio de Mínimos Privilegios**: Es recomendable dar siempre los
  permisos mínimos necesarios
- **Servicio Global**: IAM es un servicio global (no está limitado a una región)

### Identificación de Cuentas

**Root Account**:

- En la consola, en el desplegable superior derecho muestra solo un Account ID
  que es único y es el ID de la cuenta principal
- En el dashboard principal puedes crear un Account Alias para personalizar el
  sign-in URL para los usuarios que creaste

**Cuenta IAM**:

- Puedes ingresar sin la sign-in personalizada, en ese caso tienes que elegir
  que ingresas con una cuenta IAM
- El ID que te pide al principio es el ID de la cuenta root o en el caso que
  le hayas puesto un alias sería el alias
- Una vez que ingreses en una cuenta IAM lo puedes verificar en el desplegable
  superior derecho que dice "IAM user: nombre del usuario" junto con el
  account ID

**Simultaneous Sign-in**:

- Puedes habilitar un simultaneous Sign-in para poder tener dos cuentas
  abiertas en el mismo navegador
- Se configura en el desplegable debajo del nombre de la cuenta (superior
  derecho)

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
- **Statement**: Uno o más statements (requerido), son las descripciones de las
  políticas. Dentro del statement tenemos:
  - **Sid**: Cada statement tiene un ID identificador también
  - **Effect**: Lo que hace el statement - permitir o denegar (Allow o Deny)
  - **Principal**: A quién se aplica la política
  - **Action**: Lista de acciones que hace la política (ej: "s3:GetObject" para
    obtener un objeto de S3)
  - **Resource**: A qué servicios o recursos se aplica la política (ej:
    "arn:aws:s3:::mybucket/*")
  - **Condition**: Campo opcional que se puede agregar para condiciones
    específicas de cuándo comienza a aplicarse la política

### Mejores Prácticas

1. **Usar grupos** en lugar de asignar políticas directamente a usuarios
2. **Principio de mínimos privilegios** - dar solo los permisos necesarios
3. **Usar políticas administradas** de AWS cuando sea posible
4. **Rotar credenciales** regularmente
5. **Habilitar MFA** para cuentas privilegiadas
6. **Monitorear** el uso de IAM con CloudTrail

---

## Progreso del Curso

✅ **Completado hasta la lección 15** - IAM & AWS CLI
