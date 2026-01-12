Feature: Gerar um usuário e o token

  @smoke @Token
  Scenario: Gerar o token para reutilização
    * def userName = 'usuario_' + java.util.UUID.randomUUID()
    * def password = '@Senha123'

    Given url baseUrl + '/Account/v1/User'
    And request

    """
    {
      "userName": "#(userName)",
      "password": "#(password)"
    }
    """

    When method post
    Then status 201

    * def userID = response.userID

    Given url baseUrl + '/Account/v1/GenerateToken'
    And request

    """
    {
      "userName": "#(userName)",
      "password": "#(password)"
    }
    """

    When method post
    Then status 200

    * def token = response.token
    * match userID != null
    * match token != null