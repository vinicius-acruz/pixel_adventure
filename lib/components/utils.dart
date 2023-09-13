bool checkCollision(player, block) {
  final playerX = player.position.x;
  final playerY = player.position.y;
  final playerWidth = player.width;
  final playerHeight = player.height;

  final blockX = block.x;
  final blockY = block.y;
  final blockWidth = block.width;
  final blockHeight = block.height;

  final fixeX = player.scale.x < 0
      ? playerX - playerWidth
      : playerX; //Fix the player flipping reference switch

  return (playerY < blockY + blockHeight && // top of player < block bottom
      playerY + playerHeight > blockY && // bottom of player > block top
      fixeX < blockX + blockWidth && // player left < block right
      fixeX + playerWidth > blockX); // player right > block left
}
