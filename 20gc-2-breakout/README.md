# Breakout

O primeiro jogo de sucesso da ATARI ([[Pong]]) ter um sucesso massivo, muitas companhia fizeram clones do jogo, o que erodiu os lucros da ATARI. A resposta deles foi fazer mais jogos inovadores para ficar na frente da competição. Breakout foi um descendente direto de pong, mas foi desenvolvido para um jogador só em vez de dois. Ele lançou em 1976.

Fun fact: Steve Jobs e Steve Wozniak (sim, os caras da apple) trabalharam junto para desenvolver o hardware necessário para rodar o Breakout. Assim como o Pong, o jogo era feito de transistors. Novamente, o jogo seria muito mais facil de fazer se você usar uma engine nova em vez de ter que começar de uma pilha de fios.

| Dificuldade  |     |
| ------------ | --- |
| Complexidade | 0,5 |
| Escopo       | 1   |
**Objetivo:**

- Criar um espaço de jogo com paredes e tetos
- Adicionar uma barra que pode ser movida para a esquerda e a direita por meio dos comandos do jogador
- Adicionar uma bola que irá bater na barra, paredes e teto.
- Adicionar no jogo objetos quadrados (tijolos) na parte de cima do espaço de jogo. (O jogo original tinha oito linhas com 16 tijolos em cada, entretanto você pode mudar o numero de tijolos dependendo do tamanho da sua area de jogo)
- Permita que a bola quique nos tijolos. Quando a bola quica, o tijolo deve desaparecer
  1. Quebrar tijolos deve aumentar a pontuação
  2. A velocidade da bola deve aumentar quando o tijolo é quebrado
- A pontuação deve ser mostrada, assim como um contador de vidas. O jogador começa com três vidas. Se o jogador perder a bola, uma vida deve ser subtraída. Quando todas vidas forem usadas, o jogo acaba.

**Metas estendidas:**

- Guarde a pontuação entre sessões e mostre do lado da pontuação do jogador.
- Adicione cores diferentes para os tijolos por linha (O jogo original era preto e branco, mas havia um filme colorido na tela para simular cores para os tijolos).
- A barra deve ficar menor quando a bola bater no teto.
