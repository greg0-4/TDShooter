
U0 SlugPlrCollision(Collider *a)
{
  Slug *temp = slug_que.next;
  while(temp != &slug_que)
  {
    Slug *next = temp->next;
    if(plr.myCollider == a)
    {
      goto col_cont;
    }
    if(plr.footCol == a)
    {
      goto col_cont;
    }
    if(temp->myCol != a)
    {
      goto col_cont;
    }

    if(AABBCollision(plr.footCol, temp->myCol))
    {
      if(plr.vel.y > 0)
      {
        plr.vel.y = -8;
        NewParticle(temp->myCol->pos.x,
        temp->myCol->pos.y,
        temp->curSprite,
        0,
        -8);
        DelSlug(temp);
        return;
        
      }
    }

    if(AABBCollision(plr.myCollider, temp->myCol))
    {
      PlayerDie;
    }
    col_cont:
    temp = next;
  }
}

U0 TurtlePlrCollision(Collider *a)
{
  Turtle *temp = turtle_que.next;
  while(temp != &turtle_que)
  {
    Turtle *next = temp->next;

    if(plr.myCollider == a)
      goto cont;
    if(plr.footCol == a)
      goto cont;
    if(temp->myCol != a)
      goto cont;

    if(AABBCollision(plr.footCol, temp->myCol))
    {
      if(plr.vel.y > 0)
      {
	plr.vel.y = -10;
	temp->Health = 0;
        return;
      }
    }


    if(AABBCollision(plr.myCollider, temp->myCol))
    {
      PlayerDie;
    }

    cont:
    temp = next;
  }
}

U0 TShellPlrCollision(Collider *a)
{
  TShell *temp = tshell_que.next;
  while(temp != &tshell_que)
  {
    TShell *next = temp->next;
    if(plr.myCollider == a)
      goto cont;
    if(plr.footCol == a)
      goto cont;
    if(temp->myCol != a)
      goto cont;

    if(AABBCollision(plr.footCol, temp->myCol))
    {
      if(plr.vel.y > 0)
      {
        plr.vel.y = -10;
	temp->Health = 0;
	return;
      }
    }

    if(AABBCollision(plr.myCollider, temp->myCol))
    {
      PlayerDie;
    }

    cont:
    temp = next;
  }
}

U0 ShroomPlrCollision(Collider *a)
{
  Shroom *temp = shroom_que.next;
  while(temp != &shroom_que)
  {
    Shroom *next = temp->next;
    if(temp->myCol != a)
      goto cont;

    if(AABBCollision(plr.myCollider, temp->myCol))
    {
      PlayerPowerUp;
      DelShroom(temp);
      return;
    }
    cont:
    temp = next;
  }
}

U0 BreakablePlrCollision(Collider *a)
{
  if(plr.vel.y < -12)
  {
    return;
  }
  Brick *br_temp = brick_que.next;
  while(br_temp != &brick_que)
  {
    Brick *br_next = br_temp->next;
    if(br_temp->myCol != a)
    {
      goto br_cont;
    }

    br_temp->isFalling = TRUE;
    isEnemyAbove(a);

    if(plr.powerUp != 0)
    {
      NewParticle(
      br_temp->myCol->pos.x,
      br_temp->myCol->pos.y,
      tex_Particle_BrickLeft,
      -4,
      0);
      
      NewParticle(
      br_temp->myCol->pos.x,
      br_temp->myCol->pos.y,
      tex_Particle_BrickRight,
      4,
      0);
      DelBrick(br_temp);
      goto br_cont;
    }

    br_cont:
    br_temp = br_next;
  }
}

U0 QuestionPlrCollision(Collider *a)
{
  QuestionBlock *temp = question_que.next;
  while(temp != &question_que)
  {
    QuestionBlock *next = temp->next;
    if(temp->myCol != a)
    {
      goto cont;
    }
    if(temp->amount <= 0)
    {
      goto cont;
    }

    isEnemyAbove(a);
    temp->isFalling = TRUE;
    if(!temp->isPowerUp)
    {
      plr.coins++;
      temp->amount--;
      NewQuestionPart(
      temp->myCol->pos.x,
      temp->myCol->pos.y,
      tex_Particle_Coin1);
      goto cont;
    }
    temp->amount--;
    if(plr.powerUp == 0)
    {
      NewQuestionPart(
      temp->myCol->pos.x,
      temp->myCol->pos.y,
      tex_Powerup_Shroom,
      1, 2);
    }
    if(plr.powerUp >= 1)
    {
      NewQuestionPart(
      temp->myCol->pos.x,
      temp->myCol->pos.y,
      tex_Powerup_Flower1,
      1, 3);
    }
    cont:
    temp = next;
  }
}

U0 FlowerPlrCollision(Collider *a)
{
  Flower *temp = flower_que.next;
  while(temp != &flower_que)
  {
    Flower *next = temp->next;
    if(temp->myCol != a)
      goto cont;
    if(AABBCollision(plr.myCollider, temp->myCol))
    {
      DelFlower(temp);
      PlayerPowerUp(FALSE);
      goto cont;
    }
    cont:
    temp = next;
  }
}

U0 CoinPlrCollision(Collider *a)
{
  Coin *temp = coin_que.next;
  while(temp != &coin_que)
  {
    Coin *next = temp->next;
    if(temp->myCol != a)
      goto cont;
    if(AABBCollision(plr.myCollider, temp->myCol))
    {
      plr.coins++;
      DelCoin(temp);
      goto cont;
    }
    cont:
    temp = next;
  }
}

U0 UpdateCam()
{
  if(plr.isFinished)
    return;

  F64 targetX = plr.myCollider->pos.x  - 320;
  if(targetX < 0)
  {
    targetX = 0;
  }

  F64 maxLimit = (current_map.width * 24) - 640 + 320;
  
  if(plr.myCollider->pos.x > maxLimit) {
    targetX = (current_map.width * 24) - 640;
  }
  camOffset.x = targetX;
  camOffset.y = 0;
}

U0 EndLevelPlrCollision(Collider *a)
{
  EndLevel *temp = endlevel_que.next;
  while(temp != &endlevel_que)
  {
    EndLevel *next = temp->next;
    if(a != temp->myCol)
    {
      goto cont;
    }

    if(AABBCollision(plr.myCollider, temp->endCol) && !plr.isFinished)
    {
      plr.isFinished = TRUE;
      F64 yPosTouch = plr.myCollider->pos.y;
      if(plr.powerUp != 0)
      {
        if(temp->pos.y - 24 > yPosTouch)
        { 
	  return;
        }

      }else{
        if(temp->pos.y - 50 > yPosTouch)
        {
 	  return;
        }

      }
      NewParticle(temp->myCol->pos.x,
      temp->myCol->pos.y,
      tex_EndLevel_Zoomer,
      1.5);
      DelCollider(temp->myCol);
      temp->myCol = NULL;
      plr.isFinished = TRUE;
      goto cont;
    }

    touch_cont:
    if(AABBCollision(plr.myCollider, temp->myCol))
    {
      NewParticle(temp->myCol->pos.x,$BK,0$
      temp->myCol->pos.y,
      tex_EndLevel_Zoomer,
      -1.5);
      DelCollider(temp->myCol);
      temp->myCol = NULL;
      plr.isFinished = TRUE;
      return;
    }
    
    cont:
    temp = next;
  }
}


U0 UpdatePlrMove()
{

  if(plr.powerUp == 0)
  {
    plr.ducking = FALSE;
  }

  if(plr.isFinished)
  {
    if(plr.endlevel_Timer > 6 * 30)
    {
      CleanUpQueues;
      Init(TRUE);
    }
    if(plr.ducking)
    {
      plr.ducking = FALSE;
      if(plr.powerUp != 0)
      {
	F64 oldSize1Y = plr.myCollider->size.y;
	plr.myCollider->size.y = PLR_BIG_SIZE_Y;
	F64 newSize1Y = plr.myCollider->size.y;
	plr.myCollider->pos.y -= newSize1Y - oldSize1Y;
      }
    }

    plr.acceleration = -1;
    plr.isWalking = TRUE;
    plr.isLookingRight = TRUE;
    plr.vel.x -= plr.acceleration;
    plr.endlevel_Timer++;
  }
  plrCol.isColTop = FALSE;
  plrCol.isColBottom = FALSE;
  plrCol.isColLeft = FALSE;
  plrCol.isColRight = FALSE;

  if(plr.powerUp != 0)
  {
    Bool isAboveMe = isAbovePlayer;
    if(keys.down && plr.grounded && !plr.isFinished)
    {
      plr.ducking = TRUE;
    }
    else if(!isAboveMe)
    {
      plr.ducking = FALSE;
    }
  }

  isAboveMe = isAbovePlayer;
  if(isAboveMe && plr.ducking)
  {
    if(keys.left && plr.ducking)
    {
      plr.vel.x = -1.5;
      plr.isLookingRight = FALSE;
    }
    if(keys.right && plr.ducking)
    {
      plr.vel.x = 1.5;
      plr.isLookingRight = TRUE;
    }
  }

  if(plr.ducking && plr.powerUp != 0 && !plr.isFinished)
  {
    F64 oldSizeY = plr.myCollider->size.y;
    plr.myCollider->size.y = 22;
    F64 newSizeY = plr.myCollider->size.y;
    plr.myCollider->pos.y -= newSizeY - oldSizeY;
  }
  else if(!plr.ducking && plr.powerUp != 0 && !plr.isFinished)
  {
    oldSizeY = plr.myCollider->size.y;
    plr.myCollider->size.y = PLR_BIG_SIZE_Y;
    newSizeY = plr.myCollider->size.y;
    plr.myCollider->pos.y -= newSizeY - oldSizeY;
  }

  if(keys.shift && !plr.isJumping && !plr.isFinished)
  {
    plr.acceleration = 2.0;
  }
  else if(!keys.shift && !plr.isJumping && !plr.isFinished)
  {
    plr.acceleration = 1.5;
  }

  if(plr.isJumping && !keys.shift && !plr.isFinished)
  {
    plr.vel.x /= FRICTION * 1.05;
  }

  if(keys.left && !plr.ducking && !plr.isFinished)
  {
    plr.vel.x -= plr.acceleration;
    plr.isLookingRight = FALSE;
    plr.isWalking = TRUE;
  }
  if(keys.right && !plr.ducking && !plr.isFinished)
  {
    plr.vel.x += plr.acceleration;
    plr.isLookingRight = TRUE;
    plr.isWalking = TRUE;
  }

  if(!plr.ducking)
  {
    plr.vel.x /= FRICTION;
  }
  else
  {
    plr.vel.x *= 0.95; 
  }

  if(Abs(plr.vel.x) < 0.1)
  {
    plr.vel.x = 0;
  }

  if(Abs(plr.vel.x) < 1)
  {
    plr.isWalking = FALSE;
  }

  plr.myCollider->pos.x += plr.vel.x;
  // X Axis collision
  Collider *temp = collider_que.next;
  while(temp != &collider_que)
  {
    Collider *next = temp->next;
    if(temp != plr.myCollider && AABBCollision(plr.myCollider, temp))
    {
      if(temp->type == 2 || temp->type == BREAKABLE_COLLIDER || temp->type == QUESTION_COLLIDER)
      {
        if(plr.vel.x > 0)
        {
          plr.myCollider->pos.x = temp->pos.x - plr.myCollider->size.x;
          plrCol.isColRight = TRUE;
        }
        else
        {
	  plr.myCollider->pos.x = temp->pos.x + temp->size.x;
          plrCol.isColLeft = TRUE;
        }
        plr.vel.x = 0;
        plr.isWalking = FALSE;
      
        goto colx_continue;
      }
    }

    if(temp != plr.myCollider)
    {
      switch(temp->type)
      {
	case ENEMY_COLLIDER:
	  SlugPlrCollision(temp);
	  TurtlePlrCollision(temp);
	break;
	case TSHELL_COLLIDER:
	  TShellPlrCollision(temp);
	break;
	case SHROOM_COLLIDER:
	  ShroomPlrCollision(temp);
	break;
        case COIN_COLLIDER:
          CoinPlrCollision(temp);
	break;
	case FLOWER_COLLIDER:
	  FlowerPlrCollision(temp);
	break;
	case ENDLEVEL_COLLIDER:
	  EndLevelPlrCollision(temp);
	break;
      }
    }
    colx_continue:
    temp = next;
  }
  plr.vel.y += plr.gravity;

  if(Abs(plr.vel.y) < 0.1)
  {
    plr.vel.y = 0;
  }


  if(plr.vel.y > 15)
  {
    plr.vel.y = 15;
  }

  plr.myCollider->pos.y += plr.vel.y;
  // Y Axis collision
  temp = collider_que.next;
  while(temp != &collider_que)
  {
    next = temp->next;
    if(temp != plr.myCollider && AABBCollision(plr.myCollider, temp))
    {
      if(temp->type == 2 || temp->type == BREAKABLE_COLLIDER || temp->type == QUESTION_COLLIDER)
      {
          if(plr.vel.y > 0)
          {
            plr.myCollider->pos.y = temp->pos.y - plr.myCollider->size.y;
	    plrCol.isColBottom = TRUE;
            plr.grounded = TRUE;
          }
          else
          {
            plrCol.isColTop = TRUE;
     	    plr.myCollider->pos.y = temp->pos.y + temp->size.y;
            if(temp->type == QUESTION_COLLIDER)
            {
	      QuestionPlrCollision(temp);
            }
	    if(temp->type == BREAKABLE_COLLIDER)
	    {
	      BreakablePlrCollision(temp);
            }
          }
          plr.vel.y = 0;
        break;
      }

    }
    temp = next;
  }
  if(!plr.grounded)
  {
    plr.isJumping = TRUE;
  }
  if(plr.vel.y != 0)
  {
    plr.grounded = FALSE;
  }
  if(keys.up && plr.grounded  && !plr.isFinished)
  {
    plr.vel.y = -12;
    plr.grounded = FALSE;
    plr.isJumping = TRUE;
  }
  if(keys.shift)
  {
    plr.walk_frameSpeedReset = 2;
  }
  else
  {
    plr.walk_frameSpeedReset = 3;
  }
  if(plr.grounded)
  {
    plr.isJumping = FALSE;
  }
  // jumping higher when holding jump
  if(keys.up && plr.vel.y < 0)
  {
    plr.gravity = 0.8;
  }
  else
  {
    plr.gravity = 1.5;
  }

  if(plr.myCollider->pos.y >= 500)
  {
    PlayerDie;
  }
  plr.headCol->pos.x = plr.myCollider->pos.x;
  plr.headCol->pos.y = plr.myCollider->pos.y - 20;
  plr.footCol->pos.x = plr.myCollider->pos.x + 2;
  plr.footCol->pos.y = plr.myCollider->size.y + plr.myCollider->pos.y;
  
}

CDC *GetPlayerWalkSprite(I8 frameNumber)
{
  if(plr.powerUp == 1)
  {
    if(plr.isLookingRight)
    {
      if(plr.ducking)
      {
	return tex_PMan_Big_DuckRight;
      }
      switch(frameNumber)
      {
        case 1: return tex_PMan_Big_Walk1Right; break;
        case 2: return tex_PMan_Big_Walk2Right; break;
        case 3: return tex_PMan_Big_Walk3Right; break;
      }
      return tex_PMan_Big_IdleRight;
    }
    else
    {
      if(plr.ducking)
      {
	return tex_PMan_Big_DuckLeft;
      }
      switch(frameNumber)
      {
        case 1: return tex_PMan_Big_Walk1Left; break;
        case 2: return tex_PMan_Big_Walk2Left; break;
        case 3: return tex_PMan_Big_Walk3Left; break;
      }
      return tex_PMan_Big_IdleLeft;
    }
    return tex_PMan_Big_IdleRight;
  }
  else if(plr.powerUp == 2)
  {
    if(plr.isLookingRight)
    {
      if(plr.ducking)
      {
	return tex_PMan_Flower_DuckRight;
      }
      switch(frameNumber)
      {
        case 1: return tex_PMan_Flower_Walk1Right; break;
        case 2: return tex_PMan_Flower_Walk2Right; break;
        case 3: return tex_PMan_Flower_Walk3Right; break;
      }
      return tex_PMan_Flower_IdleRight;
    }
    else
    {
      if(plr.ducking)
      {
	return tex_PMan_Flower_DuckLeft;
      }
      switch(frameNumber)
      {
        case 1: return tex_PMan_Flower_Walk1Left; break;
        case 2: return tex_PMan_Flower_Walk2Left; break;
        case 3: return tex_PMan_Flower_Walk3Left; break;
      }
      return tex_PMan_Flower_IdleLeft;
    }
    return tex_PMan_Flower_IdleRight;
  }
  else
  {
    if(plr.isLookingRight)
    {
      switch(frameNumber)
      {
        case 1: return tex_PMan_Walk1Right; break;
        case 2: return tex_PMan_Walk2Right; break;
        case 3: return tex_PMan_Walk3Right; break;
      }
      return tex_PMan_IdleRight;
    }
    else
    {
      switch(frameNumber)
      {
        case 1: return tex_PMan_Walk1Left; break;
        case 2: return tex_PMan_Walk2Left; break;
        case 3: return tex_PMan_Walk3Left; break;
      }
      return tex_PMan_IdleLeft;
    }
    return tex_PMan_IdleRight;

  }
}

CDC *GetPlayerIdleSprite()
{
  if(plr.powerUp == 1)
  {
    if(plr.isLookingRight)
    {
      if(plr.ducking)
      {
	return tex_PMan_Big_DuckRight;
      }
      return tex_PMan_Big_IdleRight;
    }
    else
    {
      if(plr.ducking)
      {
	return tex_PMan_Big_DuckLeft;
      }
      return tex_PMan_Big_IdleLeft;
    }
  }
  else if(plr.powerUp == 2)
  {
    if(plr.isLookingRight)
    {
      if(plr.ducking)
      {
	return tex_PMan_Flower_DuckRight;
      }
      return tex_PMan_Flower_IdleRight;
    }
    else
    {
      if(plr.ducking)
      {
	return tex_PMan_Flower_DuckLeft;
      }
      return tex_PMan_Flower_IdleLeft;
    }
   
  }
  else
  {
    if(plr.isLookingRight)
    {
      return tex_PMan_IdleRight;
    }
    else
    {
      return tex_PMan_IdleLeft;
    }
    return tex_PMan_IdleLeft;
  }
}

CDC *GetPlayerJumpSprite()
{
  if(plr.powerUp == 1)
  {
    if(plr.isLookingRight)
    {
      if(plr.ducking)
      {
	return tex_PMan_Big_DuckRight;
      }
      return tex_PMan_Big_JumpRight;
    }
    else
    {
      if(plr.ducking)
      {
	return tex_PMan_Big_DuckLeft;
      }
      return tex_PMan_Big_JumpLeft;
    }
  }
  else if(plr.powerUp == 2)
  {
    if(plr.isLookingRight)
    {
      if(plr.ducking)
      {
	return tex_PMan_Flower_DuckRight;
      }
      return tex_PMan_Flower_JumpRight;
    }
    else
    {
      if(plr.ducking)
      {
	return tex_PMan_Flower_DuckLeft;
      }
      return tex_PMan_Flower_JumpLeft;
    }
  }
  else
  {
    if(plr.isLookingRight)
    {
      return tex_PMan_JumpRight;
    }
    else
    {
      return tex_PMan_JumpLeft;
    }
    return tex_PMan_IdleLeft;
  }

}


U0 UpdatePlayerAnimation()
{
   plr.curSprite = GetPlayerIdleSprite;
  if(plr.isWalking && !plr.isJumping)
  {
    plr.walk_frameSpeed--;
    if(plr.walkFrame > 3)
    {
      plr.walkFrame = 1;
    }
    if(plr.walk_frameSpeed <= 0)
    {
      plr.walkFrame++; 
      plr.walk_frameSpeed = plr.walk_frameSpeedReset;
    }

    plr.curSprite = GetPlayerWalkSprite(plr.walkFrame);
  }
  if(plr.isJumping)
  {
    plr.curSprite = GetPlayerJumpSprite;
  }
 

}

U0 UpdateMousePos()
{
  g_MouseX = ms.pos.x;
  g_MouseY = ms.pos.y;
}

Bool CheckBulletCollision(Bullet *bullet)
{
  Collider *temp = collider_que.next;
  while(temp != &collider_que)
  {
    Collider *next = temp->next;
    if(temp != bullet->myCollider && AABBCollision(bullet->myCollider, temp) && temp->type == 2)
    {
      // DelBullet(bullet);
      return TRUE;
    }
    temp = next;
  }
  return FALSE;
}

// Enemy logic
U0 EnemyCollisions(Enemy *a, Bool yAxis = FALSE)
{

  // Ignore if enemy marked for death
  if(a->Health <= 0) return;

  // X axis collision loop
  Collider *temp = collider_que.next;
  while(temp != &collider_que)
  {
    Collider *next = temp->next;
    Bool isPlr = isColliderPlayer(temp);
    if(isPlr)
    {
      goto enemy_continue;
    }
    if(temp == a->myCol)
    {      
      goto enemy_continue;
    }



    if(a->myCol->type == ENEMY_COLLIDER && temp->type == ENEMY_COLLIDER)
    {
      goto enemy_shell_cont;
    }

    if(a->myCol->type == TSHELL_COLLIDER || temp->type == TSHELL_COLLIDER)
    {
      goto enemy_shell_cont;
    }
 

    enemy_shell_cont:

    if(AABBCollision(a->myCol, temp))
    {

      if(a->myCol->type == ENEMY_COLLIDER && temp->type == FIREBALL_COLLIDER)
      {
	// Fucking fireballs for some reason dont get fucking deleted
	// So im forced to make a loop here
	Fireball *ftemp = fireball_que.next;
	while(ftemp != &fireball_que)
	{
	  Fireball *fnext = ftemp->next;
	  if(ftemp->myCol != temp)
	  {
	    goto fire_cont;
	  }
	  a->Health = -1;
	  DelFireball(ftemp);
	  fire_cont:
	  ftemp = fnext;
	}
        goto enemy_continue;
      }

      if(a->myCol->type == TSHELL_COLLIDER && temp->type == FIREBALL_COLLIDER)
      {
	a->Health = 0;
	goto enemy_continue;
      }

      if(a->myCol->type == SHROOM_COLLIDER && 
       temp->type != WALL_COLLIDER && 
       temp->type != BREAKABLE_COLLIDER &&
       temp->type != QUESTION_COLLIDER)
      {
        goto enemy_continue;
      }

      if(a->myCol->type == ENEMY_COLLIDER && temp->type == ENEMY_COLLIDER)
      {
	goto bounceOff;
      }


      if(a->myCol->type == TSHELL_COLLIDER && temp->type == ENEMY_COLLIDER)
      {
	Enemy *e_temp = slug_que.next;
	while(e_temp != &slug_que)
	{
	   Enemy *e_next = e_temp->next;
	   if(e_temp->myCol == temp)
	   {
	     e_temp->Health = 0;
	     goto enemy_continue;
	   }
	   e_temp = e_next;
	}
	e_temp = turtle_que.next;
	while(e_temp != &turtle_que)
	{
	   e_next = e_temp->next;
	   if(e_temp->myCol == temp)
	   {
	     e_temp->Health = 0;
	     goto enemy_continue;
	   }
	   e_temp = e_next;
	}
      }

      if(a->myCol->type == ENEMY_COLLIDER && temp->type == TSHELL_COLLIDER)
      {
	a->Health = 0;
	return;
      }

      if(a->myCol->type == TSHELL_COLLIDER && temp->type == TSHELL_COLLIDER)
      {
        a->Health = 0;
        TShell *shell_temp = tshell_que.next;
	while(shell_temp != &tshell_que)
	{
	   TShell *shell_next = shell_temp->next;
	   if(shell_temp->myCol == temp)
	   {
	     shell_temp->Health = 0;
	     break;
	   }
	   shell_temp = shell_next;
	}
	return;
      }


      bounceOff:
      if(!yAxis)
      {
	if(a->vel.x < 0)
	{
          a->myCol->pos.x = temp->pos.x + temp->size.x;
	}
	else
	{
          a->myCol->pos.x = temp->pos.x - a->myCol->size.x;
	}
	a->isLookingRight = !a->isLookingRight;
        goto enemy_continue;
      }
      else
      {
 	if(a->vel.y < 0)
	{
	  a->myCol->pos.y = temp->pos.y - a->myCol->size.y;
	}
	 else
	{
	  a->myCol->pos.y = temp->pos.y - a->myCol->size.y;
	}
	a->vel.y = 0;
      }

    }
    enemy_continue:
    temp = next;
  }
}



U0 UpdateEnemy(Enemy *a)
{ 
  if(!a->active)
  {
    if(a->myCol->pos.x - camOffset.x < 640)
    {
      a->active = TRUE;
    }
    else
    {
      return;
    }
  }
  if(a->isLookingRight)
  {
    a->vel.x = a->speed;
  }
  else
  {
    a->vel.x = -a->speed;
  }
  a->myCol->pos.x += a->vel.x;
  EnemyCollisions(a);
  a->vel.y += GRAVITY; 
  a->myCol->pos.y += a->vel.y;
  EnemyCollisions(a, TRUE);
}

CDC GetSlugSprite(Slug *a)
{
  if(a->isLookingRight)
  {
    switch(a->curFrame)
    {
      default: return tex_Slug_Walk1Right; break;
      case 1: return tex_Slug_Walk1Right; break;
      case 2: return tex_Slug_Walk2Right; break;
    }
  }
  else
  {
    switch(a->curFrame)
    {
      default: return tex_Slug_Walk1Left; break;
      case 1: return tex_Slug_Walk1Left; break;
      case 2: return tex_Slug_Walk2Left; break;
    }
  }
}

U0 UpdateSlugAnimation(Slug *a)
{
  a->walk_frameSpeed--;
  a->curSprite = GetSlugSprite(a);
  if(a->curFrame > 2)
  {
    a->curFrame = 1;
  }
  if(a->walk_frameSpeed <= 0)
  {
    a->walk_frameSpeed = 5;
    a->curFrame++;
  } 
}

U0 UpdateSlugs()
{
  Slug *temp = slug_que.next;
  while(temp != &slug_que)
  {
    Slug *next = temp->next;
    UpdateEnemy(temp);
    UpdateSlugAnimation(temp);
    if(temp->Health <= 0)
    {
      NewParticle(temp->myCol->pos.x,
      temp->myCol->pos.y,
      temp->curSprite);
      DelSlug(temp);
      goto slug_nxt;
    }
    slug_nxt:
    temp = next;
  }
}



U0 UpdateParticles()
{
  Particle *temp = particle_que.next;
  while(temp != &particle_que)
  {
    Particle *next = temp->next;
    temp->pos.x += temp->vel.x;
    temp->vel.y += GRAVITY;
    temp->pos.y += temp->vel.y;
    if(temp->pos.y - camOffset.y > 500)
      DelParticle(temp);
    temp = next;
  }
}


CDC *GetTurtleSprite(Turtle *a)
{
  if(a->isLookingRight)
  {
    switch(a->curFrame)
    {
      default: return tex_Turtle_Walk1Right; break;
      case 1: return tex_Turtle_Walk1Right; break;
      case 2: return tex_Turtle_Walk2Right; break;
    }
  }
  else
  {
    switch(a->curFrame)
    {
      default: return tex_Turtle_Walk1Left; break;
      case 1: return tex_Turtle_Walk1Left; break;
      case 2: return tex_Turtle_Walk2Left; break;
    }
  }
}

U0 UpdateTurtleAnimation(Turtle *a)
{
  a->walk_frameSpeed--;
  a->curSprite = GetTurtleSprite(a);
  if(a->curFrame > 2)
  {
    a->curFrame = 1;
  }
  if(a->walk_frameSpeed <= 0)
  {
    a->walk_frameSpeed = 10;
    a->curFrame++;
  }
}

U0 UpdateTurtles()
{
  Turtle *temp = turtle_que.next;
  while(temp != &turtle_que)
  {
    Turtle *next = temp->next;
    UpdateEnemy(temp);
    UpdateTurtleAnimation(temp);
    if(temp->Health == -1)
    {

      NewParticle(temp->myCol->pos.x,
      temp->myCol->pos.y,
      tex_Turtle_Shell);
      DelTurtle(temp);
    }
    if(temp->Health == 0)
    {
      NewTShell(temp->myCol->pos.x,
      temp->myCol->pos.y,
      plr.isLookingRight);
      DelTurtle(temp);
      goto turtle_nxt;
    }
    turtle_nxt:
    temp = next;
  }
}

U0 UpdateTShells()
{
  TShell *temp = tshell_que.next;
  while(temp != &tshell_que)
  {
    TShell *next = temp->next;
    UpdateEnemy(temp);
    if(temp->Health <= 0)
    {
      NewParticle(temp->myCol->pos.x,
      temp->myCol->pos.y,
      temp->curSprite);
      DelTShell(temp);
      goto tshell_nxt;
    }
    tshell_nxt:

    temp = next;
  }
}


// Sorry for this global variable
// Amount of cycles of immune flash to become no longer immune
// Should be 4
// This was a bad idea, couldnt really set it in globals
//I8 immuneOver = 0;

U0 UpdatePlayerImmune()
{
  if(plr.immuneCycles >= 15)
  {
    plr.immune = FALSE;
    plr.immuneFlash = FALSE;
    plr.immuneCycles = 0;
  }
  if(plr.immune)
  {
    plr.immuneTimer--;
    if(plr.immuneTimer <= 0)
    {
      plr.immuneFlash = !plr.immuneFlash;
      plr.immuneTimer = 5;
      plr.immuneCycles++;
    }
  }
}

U0 UpdatePauseTimer()
{
  if(g_Paused)
  {
    plr.pauseTimer--;
    if(plr.pauseTimer <= 0)
    {
      g_Paused = FALSE;
      plr.pauseTimer = 15;      
    }
  }
}


U0 UpdateShrooms()
{
  Shroom *temp = shroom_que.next;
  while(temp != &shroom_que)
  {
    Shroom *next = temp->next;
    UpdateEnemy(temp);
    temp = next;
  }
}

U0 UpdateBreakable(Breakable *a)
{
  if(!a->isFalling)
  {
    a->offsetY = Lerp(a->offsetY, -5.0, 0.3);
    if(a->offsetY <= -4.0)
    {
      a->isFalling = TRUE;
    }
  }
  else
  {
    a->offsetY = Lerp(a->offsetY, 0.0, 0.3);
    if(a->offsetY > -0.1)
    {
      a->offsetY = 0;
      a->isFalling = FALSE;
    }
  }
}

U0 UpdateBreakables()
{
  Brick *br_temp = brick_que.next;
  while(br_temp != &brick_que)
  {
    Brick *br_next = br_temp->next;
    UpdateBreakable(br_temp);
    br_cont:
    br_temp = br_next;
  }
}


U0 UpdateQuestion(QuestionBlock *a)
{  
  if(a->amount != 0)
  {
    if(a->hidden)
    {
      a->curSprite = tex_Brick;
      goto sprite_cont;
    }
    a->glowTimer--;
    if(a->glowing)
    {
      a->curSprite = tex_Question1;
    }
    else
    {
      a->curSprite = tex_Question2;
    }
    if(a->glowTimer <= 0)
    {
      a->glowing = !a->glowing;
      a->glowTimer = 8;
    }
  }

  sprite_cont:
  if(a->amount <= 0)
  {
    a->amount = 0;
    a->curSprite = tex_Question3;
  }

  if(!a->isFalling)
  {
    a->offsetY = Lerp(a->offsetY, -5.0, 0.3);
    if(a->offsetY <= -4.0)
    {
      a->isFalling = TRUE;
    }
  }
  else
  {
    a->offsetY = Lerp(a->offsetY, 0.0, 0.3);
    if(a->offsetY > -0.1)
    {
      a->offsetY = 0;
      a->isFalling = FALSE;
    }
  }
}

U0 UpdateQuestions()
{
  QuestionBlock *temp = question_que.next;
  while(temp != &question_que)
  {
    QuestionBlock *next = temp->next;
    UpdateQuestion(temp);
    temp = next;
  }
}

U0 UpdateQuestionPart(QuestionPart *a)
{

  // Coin
  if(a->type == 1)
  {
    
    a->frameTimer--;

    if(a->curFrame > 3)
    {
      a->curFrame = 1;
    }

    switch(a->curFrame)
    {
      default: a->curSprite = tex_Particle_Coin1; break;
      case 1: a->curSprite = tex_Particle_Coin1; break;
      case 2: a->curSprite = tex_Particle_Coin2; break;
      case 3: a->curSprite = tex_Particle_Coin3; break;      
    }

    if(a->frameTimer <= 0)
    {
      a->frameTimer = a->timerReset;
      a->curFrame++;
    }

    if(!a->isFalling)
    {
      a->offsetY += 10;
    }
    if(a->offsetY > 60)
    {
      DelQuestionPart(a);
    }
    return;
  }
  // Shroom
  if(a->type == 2)
  {
    a->offsetY += 1;
    if(a->offsetY > 25)
    {
      NewShroom(a->pos.x, a->pos.y - 25);
      DelQuestionPart(a);
      return;
    }
  }
  if(a->type == 3)
  {
    a->offsetY += 1;
    if(a->offsetY > 25)
    {
      NewFlower(a->pos.x, a->pos.y - 25);
      DelQuestionPart(a);
      return;
    }
  }
}

U0 UpdateQuestionParts()
{
  QuestionPart *temp = questionpart_que.next;
  while(temp != &questionpart_que)
  {
    QuestionPart *next = temp->next;
    UpdateQuestionPart(temp);
    temp = next;
  }
}


U0 UpdateCoin(Coin *a)
{
  a->glowingTimer--;

  if(a->glowing)
  {
    a->curSprite = tex_Coin1;
  }
  else
  {
    a->curSprite = tex_Coin2;
  }

  if(a->glowingTimer <= 0)
  {
    a->glowingTimer = 5;
    a->glowing = !a->glowing;
  }
}

U0 UpdateCoins()
{
  Coin *temp = coin_que.next;
  while(temp != &coin_que)
  {
    Coin *next = temp->next;
    UpdateCoin(temp);
    temp = next;
  }
}

U0 UpdateFlower(Flower *a)
{
  a->glowingTimer--;

  if(a->glowing)
  {
    a->curSprite = tex_Powerup_Flower1;
  }
  else
  {
    a->curSprite = tex_Powerup_Flower2;
  }

  if(a->glowingTimer <= 0)
  {
    a->glowingTimer = 5;
    a->glowing = !a->glowing;
  }

}


U0 UpdateFlowers()
{
  Flower *temp = flower_que.next;
  while(temp != &flower_que)
  {
    Flower *next = temp->next;
    UpdateFlower(temp);
    temp = next; 
  }
}

U0 FireballCollisions(Fireball *a, Collider *temp, Bool yAxis = FALSE)
{
  if(!yAxis)
  {
    if(AABBCollision(a->myCol, temp))
    {
      switch(temp->type)
      {
	case WALL_COLLIDER: 
	case BREAKABLE_COLLIDER:
	case QUESTION_COLLIDER:
	case ENEMY_COLLIDER:
	case TSHELL_COLLIDER:
	  a->delete = TRUE;
	  return;
        break;
      }
    }
  }
  else
  {
    if(AABBCollision(a->myCol, temp))
    {
      switch(temp->type)
      {
	case WALL_COLLIDER:
	case BREAKABLE_COLLIDER:
	case QUESTION_COLLIDER:
	if(a->vel.y > 0)
	{
	  a->myCol->pos.y = temp->pos.y - a->myCol->size.y;
	  a->vel.y = -8;
	}
        else
        {
	  a->vel.y = 0;
        }
	
	break;
      }
    }
  }

}

U0 UpdateFireball(Fireball *a)
{

  a->myCol->pos.x += a->vel.x;
  Collider *temp = collider_que.next;
  while(temp != &collider_que)
  {
    Collider *next = temp->next;

    Bool isPlr = isColliderPlayer(temp);
    if(isPlr)
      goto cont_x;
    if(a->myCol == temp)
      goto cont_x;
    FireballCollisions(a, temp);
    cont_x:
    temp = next;
  }
  a->vel.y += GRAVITY;
  if(a->vel.y > 8)
    a->vel.y = 8;
  a->myCol->pos.y += a->vel.y;
  temp = collider_que.next;
  while(temp != &collider_que)
  {
    next = temp->next;

    isPlr = isColliderPlayer(temp);
    if(isPlr)
      goto cont_y;
    if(a->myCol == temp)
      goto cont_y;
    FireballCollisions(a, temp, TRUE);
    cont_y:
    temp = next;
  }

  F64 posX = a->myCol->pos.x - camOffset.x;
  F64 posY = a->myCol->pos.y - camOffset.y;

  if(posX <= -24)
  {
    a->delete = TRUE;
    return;
  }

  if(posX > 660)
  {
    DelFireball(a);
    return;
  }

  if(posY > 480)
  {
    DelFireball(a);
    return;
  }

  if(posY <= - 24)
  {
    DelFireball(a);
    return;
  }
  
}

U0 UpdateFireballAnim(Fireball *a)
{
  a->frameTimer--;

  switch(a->curFrame)
  {
    default: a->curSprite = tex_Fireball1; break;
    case 1: a->curSprite = tex_Fireball1; break;
    case 2: a->curSprite = tex_Fireball2; break;
    case 3: a->curSprite = tex_Fireball3; break;
    case 4: a->curSprite = tex_Fireball4; break;
  }

  if(a->curFrame > 4)
  {
    a->curFrame = 1;
  }
  if(a->frameTimer <= 0)
  {
    a->curFrame++;
    a->frameTimer = 5;
  }
}

U0 UpdateFireballs()
{
  Fireball *temp = fireball_que.next;
  while(temp != &fireball_que)
  {
    Fireball *next = temp->next;

    UpdateFireballAnim(temp);
    UpdateFireball(temp);
    if(temp->delete)
    {
      goto cont;
    }
    cont:
    temp = next;
  }
}

U0 UpdateEndLevel(EndLevel *a)
{

  if(a->myCol == NULL)
  {
    return;
  }

  if(a->bounceDown)
  {
    a->myCol->pos.y -= 3;
  }
  else
  {
    a->myCol->pos.y += 3;
  }
  a->yOffset = a->pos.y - a->myCol->pos.y;

  if(a->yOffset < 0)
  {
    a->bounceDown = !a->bounceDown;
  }

  if(a->yOffset > 80)
  {
    a->bounceDown = !a->bounceDown;
  }
}

U0 UpdateEndLevels()
{
  EndLevel *temp = endlevel_que.next;
  while(temp != &endlevel_que)
  {
    EndLevel *next = temp->next;
    UpdateEndLevel(temp);
    temp = next;
  }
}























