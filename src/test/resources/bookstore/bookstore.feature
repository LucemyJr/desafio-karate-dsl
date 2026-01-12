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

  Scenario: Adicionar um livro ao usuário com sucesso
    * def userID = auth.userID
    * def isbn = firstISBN
    Given path '/Bookstore/v1/Books'
    And header Authorization = 'Bearer ' + token
    And request

    """
     {
      "userID": "#(userID)",
      "CollectionOfIsbn": [
        {"isbn": "#(isbn)"}
      ]
     }
    """

    When method post
    Then status 201
    * match response.books[0].isbn == isbn

  Scenario: Adicionar um livro ao usuário (falha)
    * def userID = auth.userID
    * def isbn = '0000000000'

    Given path '/Bookstore/v1/Books'
    And header Authorization = 'Baerer ' + token
    And request

    """
    {
      "userID": "#(userID)",
      "CollectionOfIsbn": [
        {"isbn": "#(isbn)"}
      ]
     }
    """

    When method post
    Then status 400