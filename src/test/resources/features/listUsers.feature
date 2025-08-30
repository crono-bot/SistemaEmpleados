@listUsersTest
Feature: Obtener lista de usuarios

    Background:
        * url baseUrl

    Scenario: Obtener todos los usuarios
        Given path '/usuarios'
        When method GET
        Then status 200
