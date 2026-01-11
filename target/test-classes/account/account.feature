Feature: Account - Testar os endpoints da conta

  Scenario: Criar usuário com sucesso
    * def userName = 'usuario_' + java.util.UUID.randomUUID()
    * def password = '@Senha123'

    Given url baseUrl + '/Account/v1/User'
    And request
  """
  {
    "userName": "#(userName)",
    "password": "@Senha123"
  }
  """
    When method post
    Then status 201
    * def userID = response.userID

  Scenario: Deletar usuário com sucesso
    * def auth = callonce read('classpath:auth/auth.feature')
    * def userID = auth.userID
    * def token = auth.token
    Given url baseUrl + '/Account/v1/User/' + userID
    And header Authorization = 'Bearer ' + token
    When method delete
    Then status 204

  Scenario: Deletar usuário inexistente (falha)
    * def auth = callonce read('classpath:auth/auth.feature')
    Given url baseUrl + '/Account/v1/User/12345'
    And header Authorization = 'Bearer ' + auth.token
    When method delete
    Then status 200
    * match response.code == '1207'

