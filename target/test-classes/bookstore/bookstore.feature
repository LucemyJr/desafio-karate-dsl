Feature: Bookstore - Testar os endpoints da loja de livros

  Background:
    * def auth = callonce read('classpath:auth/auth.feature')
    * def token = auth.token
    * url baseUrl

  Scenario: Listar os livros com sucesso
    Given path '/Bookstore/v1/Books'
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    * def firstISBN = response.books[0].isbn

  Scenario: Listrar livros (falha)
    Given path '/BookStore/v1/Books'
    And header Authorization = 'Bearer invalido'
    When method get
    Then status 401