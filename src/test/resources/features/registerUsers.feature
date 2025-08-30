@registerTest
Feature: Registro de usuario

  Background:
    * url baseUrl
    * def generateData = Java.type('helpers.generateData')
    * def email = generateData.emailRandom()
    * def password = generateData.passwordRandom(10)

  @request
  Scenario Outline: <CP>: Validación de Request - <RESPUESTA>
    Given path '/usuarios'
    * def body = read("../request/RQ_user.json")
    * set body.nome = '<NOME>'
    * set body.email = <EMAIL>
    * set body.password = '<PASSWORD>'
    * set body.administrador = '<ADMINISTRADOR>'
    And request body
    When method POST
    Then status <CODE>
    Examples:
      | CP       | NOME  | EMAIL         | PASSWORD | ADMINISTRADOR | RESPUESTA | CODE
      | CASO 001 | Juan  | email         | password | true          | Valido    | 201
      | CASO 002 |       | email         | password | false         | Invalido  | 400
      | CASO 003 | Juan  | email         | password | true          | Valido    | 201
      | CASO 004 | Pablo | ''            | password | false         | Invalido  | 400
      | CASO 005 | Juan  | email         | password | true          | Valido    | 201
      | CASO 006 | Pablo | email         |          | false         | Invalido  | 400
      | CASO 007 | Pablo | email         | password | false         | Valido    | 201
      | CASO 008 | Juan  | email         | password | true          | Valido    | 201
      | CASO 009 | Pablo | email         | password |               | Invalido  | 400

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