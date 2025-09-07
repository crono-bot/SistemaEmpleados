# 🥋 Proyecto CRONOBOT: Automatización de pruebas BackEnd

Este proyecto implementa pruebas automatizadas de **APIs REST** utilizando [Karate DSL](https://github.com/karatelabs/karate).  
Karate combina **BDD (Behavior Driven Development)** con un potente motor para pruebas de servicios, permitiendo definir los tests en un lenguaje legible y a la vez muy flexible.  

El objetivo de este proyecto es contar con una arquitectura ordenada que facilite la **escalabilidad, reutilización y ejecución en distintos ambientes** (`dev`, `qa`, `prod`).

---

## 📂 Estructura del Proyecto

```
src
└── test
    ├── java
    │   ├── helpers/           # Funciones auxiliares reutilizables
    │   │   └── generateData   # Ejemplo: generación de datos dinámicos
    │   └── runner/            # Clases para ejecutar los tests
    │       ├── testRunner.java
    │       └── TestParallel.java
    │
    └── resources
        ├── features/          # Archivos .feature con escenarios de prueba
        │   ├── deleteUsers.feature
        │   ├── listUsers.feature
        │   ├── registerUsers.feature
        │   ├── updateUsers.feature
        │   └── userID.feature
        │
        ├── request/           # Requests reutilizables en plantilla JSON
        │   └── RQ_user.json
        │
        └── karate-config.js   # Configuración global de Karate
```

---

## 📌 Explicación de Carpetas y Archivos

### 🔹 **karate-config.js**
Es el archivo de configuración global de Karate.  
Se ejecuta automáticamente al inicio de las pruebas y define:
- **Ambientes** (`dev`, `qa`, `prod`, etc.)
- **Variables globales** (`baseUrl`, headers, tokens)
- **Configuración común** para todos los escenarios  

Ejemplo:
```js
function fn() {
  var env = karate.env;
  karate.log('Ambiente actual:', env);

  var config = {};

  if (!env) {
    env = 'dev';
  }

  if (env == 'dev') {
    config.baseUrl = 'https://serverest.desa';
  }

  else if (env == 'qa') {
    config.baseUrl = 'https://serverest.dev';
  }

  else if (env == 'prod') {
    config.baseUrl = 'https://serverest.prod';
  }

  return config;
}
```

---

### 🔹 **features/**
Aquí se encuentran los archivos `.feature` que contienen los **escenarios de prueba** escritos en Gherkin.  

Ejemplo (`deleteUsers.feature`):
```gherkin
@listUsersTest
Feature: Obtener lista de usuarios

  Background:
    * url baseUrl

  Scenario: Obtener todos los usuarios
    Given path '/usuarios'
    When method GET
    Then status 200
```

Cada `Feature` puede tener múltiples escenarios, y se pueden etiquetar con `@tags` para filtrar su ejecución.

---

### 🔹 **request/**
Carpeta para guardar **plantillas JSON reutilizables** que funcionan como cuerpo de las peticiones.  
Esto permite mantener los `.feature` más limpios y centralizar las estructuras de request.

Ejemplo (`RQ_user.json`):
```json
{
  "nome": "Testing de Pruebas",
  "email": "testing@qa.com.br",
  "password": "testing",
  "administrador": "true"
}
```

Uso en un feature:
```gherkin
@register
Scenario Outline: <CP>: <DETALLE> - <RESPUESTA>
* def user = call read('classpath:features/listUsers.feature')
* def emailResponse = user.response.usuarios[0].email
Given path '/usuarios'
* def body = read("../request/RQ_user.json")
* set body.email = <EMAIL>
And request body
When method POST
Then status <CODE>
* print body
Examples:
| CP       | DETALLE                                 | EMAIL         | RESPUESTA | CODE |
| CASO 001 | Validar registro de un nuevo usuario    | email         | Valido    | 201  |
| CASO 002 | Validar registro de un correo existente | emailResponse | Invalido  | 400  |
```

---

### 🔹 **helpers/**
Funciones auxiliares (JS/Java) para lógica común o generación de datos dinámicos.  

Ejemplo (`generateData.java`):
```java
public class generateData {
    public static String emailRandom() {
        return "user_" + UUID.randomUUID().toString() + "@mail.com";
    }

    private static final String PASSWORD_CHARS =
            "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()";

    private static final Random random = new Random();

    public static String passwordRandom(int length) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < length; i++) {
            int index = random.nextInt(PASSWORD_CHARS.length());
            sb.append(PASSWORD_CHARS.charAt(index));
        }
        return sb.toString();
    }
}
```

Uso en un `.feature`:
```gherkin
Background:
* url baseUrl
* def generateData = Java.type('helpers.generateData')
* def email = generateData.emailRandom()
* def password = generateData.passwordRandom(10)
```

---

### 🔹 **runner**
Clases Java para ejecutar los tests con JUnit.

- **testRunner.java** → Ejecuta todos los features.
```java
package runner;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;

class TestParallel {

    @Test
    void testParallel() {
        Results results = Runner.path("classpath:features").karateEnv("qa").parallel(5);
        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }

}
```
---
## ▶️ Ejecución de los Tests

El proyecto se ejecuta con **Maven**.  
Se pueden usar parámetros para definir **ambiente** y **tags**.

### 🔹 Ejecutar todos los tests en el ambiente de `qa`
```bash
mvn test -Dkarate.env=qa
```

### 🔹 Ejecutar tests por ambiente y filtrando por tag
```bash
mvn test -Dkarate.env=qa -Dkarate.options="--tags @deleteTest"
```

### 🔹 Ejecutar un feature específico
```bash
mvn test -Dkarate.options="classpath:features/deleteUsers.feature"
```

---
## 📊 Reportes

Karate genera reportes automáticos en:
```
target/karate-reports/karate-summary.html
```

Abrir este archivo en un navegador para visualizar resultados detallados de los tests (escenarios ejecutados, pasos, tiempos de respuesta, errores, etc.).

---

## 🚀 Buenas Prácticas

- Usar **helpers** para datos dinámicos y lógica reutilizable.  
- Centralizar **requests** en la carpeta `request/`.  
- Usar **tags** para ejecutar subconjuntos de pruebas.  
- Mantener `karate-config.js` como única fuente para URLs y headers.  
- Documentar cada `Feature` con una breve descripción del propósito.  

---
