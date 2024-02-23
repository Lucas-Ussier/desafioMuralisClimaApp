# desafioMuralisClimaApp
  Desafio Técnico Muralis Analista Desenvolvedor Swift

# Requisitos para rodar o projeto
  Dispositivo Apple (iPhone) com o sistema operacional iOS 15.0 ou superior
  Para a construção do aplicativo foi utilizado o Xcode na versão 15.2 (15C500b), e o sistema operacional utilizado foi o macOS 14.2.1 (23C71)

# UI
  Para a UI foi utilizado o framework Storyboard.
  Este framework foi utilizado pois é o mais indicado para projetos com poucas telas, dado a facilidade de construir as telas de maneira mais rápida.

# Estrutura de Arquivos
  Para a estrutura de arquivos foi utilizada a estrutura MVVM (Model-View-ViewModel) levemente adaptada.
  Para este projeto, na camada de Model foi feito um arquivo para cada estrutura de dados utilizada no projeto, o Model é comumente utilizado para fins de retorno de chamadas de API.
  Na camada de View, que neste caso são os arquivos chamados de ViewControllers, foram feitas as ligações dos componentes do storyboard e também algumas configurações extras relacionadas à view
  Na camada de ViewModel, que foi utilizada somente para uma ViewController, é onde normalmente fica a parte de regra de negócios, para este projeto foi utilizada para algumas configurações de tela que optou-se separar da ViewController

#Overview do Projeto
  O projeto consiste em um aplicativo de Meteorologia. O aplicativo está na Lingua Inglesa
  O aplicativo começa com uma tela de login que pede um usuário (username) e uma senha (password). 
  Ao realizar o login, caso algum dos campos esteja vazio, ou algum deles estejam errados ou ainda tenha algum erro no servidor, é mostrado um alerta de erro para o usuário.
  Quando o login for bem sucedido, o usuário irá para uma tela de menu, onde são apresentados 3 opções: "Measurements"(Medições), "Settings"(Preferências) e "Logout"(Sair).
  As opções são clicáveis e cada opção tem uma ação diferente.

# Telas

  # Login
  É a primeria tela do aplicativo, nela o usuário vê a logo da muralis, dois textfields e um botão. Nos textfields estão indicados para colocar o e-mail e a senha. Ao clicar no textField é possível editá-lo e digitar, e ao clicar no botão "return" (botão próprio do teclado do sistema Apple), o teclado é recolhido e o usuário tem acesso ao botão para realizar o login.

  # Measurements (Medições)
  A opção "Measurements" leva a uma tela que contem uma tabela com medições. As medições são separadas em seções relativas às datas de cada medição, e nesta tela em cada linha temos informações resumidas de cada medição, sendo estas: 
  A hora, uma imagem e a descrição do clima, a temperatura e a precipitação das respectivas medições.
  Cada linha da tabela é clicável, e ao clicar é mostrado ao usuário um modal que contem os detalhes da medição que foi clicada. A tela de detalhes será contemplada adiante.
  A tela foi construída de modo com que quando o usuário vai chegando ao final da lista a mesma carrega mais medições, até o total de itens que sempre é mostrado num rodapé fixo presente na tela. Para essa funcionalidade foi utilizado uma biblioteca externa que será descrita adiante neste documento.
  
  # Settings(Ajustes)
  A opção "Settings" leva o usuário a uma tela de ajustes, que apresenta ao usuário algumas opções de unidades de medida para alguns dos atributos presentes no aplicativo, tais como temperatura, precipitação, velocidade do vento, pressão e visibilidade. Para alterar o usuário deve clicar no botão à direita, onde abre um menu com duas opções, para alterar basta selecionar a opçao no menu e ao voltar ao menu do aplicativo, as opções são salvas automaticamente.
  
  # Logout(Sair)
  A opção de "Logout" apresenta ao usuário um alerta que avisa ao usuário que ele está saindo e se deseja prosseguir, caso ele clique na opção "Yes" o usuário volta para a tela de login, caso ele clique na opção "No"ele continua na tela de Menu principal do aplicativo.

  # Detalhes da medição
  Ao clicar em alguma medição na tela "Measurements", o usuário irá ver um modal que apresenta uma tela com detalhes da medição clicada. Os detalhes que aparecem são: temperatura, precipitação, humidade, velocidade do vento, direção do vento, pressão, visibilidade, data e data da ultima modificação, além de uma imagem no início do modal representando a condição climática.


# Biblioteca externa: UIScrollView_InfiniteScroll
  Para este projeto foi utilizada esta biblioteca externa para facilitar a manutenção do código, por se tratar de uma maneira simplificada de implementar a funcionalidade.
  Para a documentação completa da biblioteca segue o link abaixo:
  http://pronebird.github.io/UIScrollView-InfiniteScroll/
