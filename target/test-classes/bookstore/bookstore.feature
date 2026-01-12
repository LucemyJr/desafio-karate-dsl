Feature: Bookstore - Testar os endpoints da loja de livros

  Background:
    * def auth = callonce read('classpath:auth/auth.feature')
    * def token = auth.token
    * url baseUrl

  @timeout
  Scenario: Adicionar um livro ao usuário com sucesso
    * def userID = auth.userID

    Given path '/Bookstore/v1/Books'
    When method get
    Then status 200
    * def isbn = response.books[0].isbn

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

  @timeout
  Scenario: Adicionar um livro ao usuário (falha)
    * def userID = auth.userID
    * def isbn = '0000000000'

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
    Then status 400

  @smoke
  Scenario: Listar catálogo de livros com sucesso
    Given path '/Bookstore/v1/Books'
    When method get
    Then status 200
    * assert response.books.length > 0