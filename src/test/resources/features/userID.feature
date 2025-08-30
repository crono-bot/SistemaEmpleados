@userIDTest
Feature: Obtener usuario por ID

  Background:
    * url baseUrl
    * def generateData = Java.type('helpers.generateData')
    * def id15 = generateData.passwordRandom(15)
    * def id17 = generateData.passwordRandom(17)

  Scenario Outline: <CP>: <DETALLE> - <RESPUESTA>
    * def user = call read('classpath:features/listUsers.feature')
    * print user.response
    * def id = user.response.usuarios[0]._id
    Given path '/usuarios/' + <ID>
    When method GET
    Then status <CODE>
    Examples:
      | CP       | DETALLE                                                      |  ID  | RESPUESTA | CODE |
      | CASO 001 | Validar respues de un usuario por ID con 16 caracteres       | id   | Valido    | 200  |
      | CASO 002 | Validar respues de un usuario por ID menor a  16 caracteres  | id15 | Invalido  | 400  |
      | CASO 002 | Validar respues de un usuario por ID mayor a  16 caracteres  | id15 | Invalido  | 400  |