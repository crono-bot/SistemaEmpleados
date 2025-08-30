@deleteTest
Feature: Obtener usuario por ID

  Background:
    * url baseUrl
    * def generateData = Java.type('helpers.generateData')
    * def id15 = generateData.passwordRandom(17)

  @carritoCompra
  Scenario: Extrae usuario con compras en el carrito
    Given path '/carrinhos'
    When method GET
    Then status 200

  @delete
  Scenario Outline: <CP>: <DETALLE> - <RESPUESTA>
    * def usersCarrito = call read('classpath:features/deleteUsers.feature@carritoCompra')
    * def idUserCompra = usersCarrito.response.carrinhos[0].idUsuario
    * def users = call read('classpath:features/listUsers.feature')
    * def usuarios = users.response.usuarios
    * def size = usuarios.length
    * def index = Math.floor(Math.random() * size)
    * def id = usuarios[index]._id
    Given path '/usuarios/', <ID>
    When method DELETE
    Then status <CODE>
    Examples:
      | CP       | DETALLE                                                        |  ID          | RESPUESTA | CODE |
      | CASO 001 | Validar eliminar un usuario por ID existente                   | id           | Valido    | 200  |
      | CASO 002 | Validar eliminar un usuario por ID no existente                | id15         | Invalido  | 200  |
      | CASO 003 | Validar eliminar un usuario que contiene compras en el carrito | idUserCompra | Invalido  | 400  |
