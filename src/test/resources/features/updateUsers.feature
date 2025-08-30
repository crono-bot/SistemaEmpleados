@updateTest
Feature: Actualizar un usuario

  Background:
    * url baseUrl
    * def generateData = Java.type('helpers.generateData')
    * def email = generateData.emailRandom()
    * def password = generateData.passwordRandom(10)

  Scenario Outline: <CP>: <DETALLE> - <RESPUESTA>
    * def users = call read('classpath:features/listUsers.feature')
    * def usuarios = users.response.usuarios
    * def size = usuarios.length
    * def index = Math.floor(Math.random() * size)
    * def id = usuarios[index]._id
    * def body = read("../request/RQ_user.json")
    * set body.nome = usuarios[index].nome
    * set body.email = usuarios[index].email
    * set body.password = usuarios[index].password
    * set body.administrador = usuarios[index].administrador
    * set body.<CAMPO> = <DATA>
    Given path '/usuarios/' + id
    And request body
    When method PUT
    Then status <CODE>
    * print 'Registro modificado: ', body
    Examples:
      | CP       | DETALLE                                                      | CAMPO         | DATA                     | RESPUESTA | CODE |
      | CASO 001 | Validar actualización del nombre de usaurio                  | nome          | 'Jose Fernandez Murillo' | Valido    | 200  |
      | CASO 002 | Validar actualización del nombre cuando este vacio           | nome          | ''                       | Invalido  | 400  |
      | CASO 003 | Validar actualización del email de usaurio                   | email         | email                    | Valido    | 200  |
      | CASO 004 | Validar actualización del email cuando este vacio            | email         | ''                       | Invalido  | 400  |
      | CASO 005 | Validar actualización del email es invalido                  | email         | 'qatest.com'             | Invalido  | 400  |
      | CASO 006 | Validar actualización del password                           | password      | password                 | Valido    | 200  |
      | CASO 007 | Validar actualización del password cuando este vacio         | password      | ''                       | Invalido  | 400  |
      | CASO 008 | Validar actualización del administrador como true            | administrador | 'true'                   | valido    | 200  |
      | CASO 009 | Validar actualización del administrador como false           | administrador | 'false'                  | Valido    | 200  |
      | CASO 010 | Validar actualización del administrador cuando este vacio    | administrador | ''                       | Invalido  | 400  |