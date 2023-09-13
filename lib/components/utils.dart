bool checkCollision(player, block) {
  final hitbox = player.hitbox;
  final playerX = player.position.x + hitbox.offsetX;
  final playerY = player.position.y + hitbox.offsetY;
  final playerWidth = hitbox.width;
  final playerHeight = hitbox.height;

  final blockX = block.x;
  final blockY = block.y;
  final blockWidth = block.width;
  final blockHeight = block.height;

  final fixedX = player.scale.x < 0
      ? playerX - (hitbox.offsetX * 2) - playerWidth
      : playerX; //Fix the player flipping reference switch
  final fixedY = block.isPlatform
      ? playerY + playerHeight
      : playerY; // Sets player Y reference when its a platform

  return (fixedY < blockY + blockHeight && // top of player < block bottom
      playerY + playerHeight > blockY && // bottom of player > block top
      fixedX < blockX + blockWidth && // player left < block right
      fixedX + playerWidth > blockX); // player right > block left
}
