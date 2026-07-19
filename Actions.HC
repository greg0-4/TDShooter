Bool isEnemyAbove(Collider *a)
{

  // Yes, using seperate thing. Would be better to have an
  // AABB function with offsets but, oh well!
  I64 zone_left = a->pos.x;
  I64 zone_right = a->pos.x + a->size.x;
  I64 zone_top = a->pos.y - 4;
  I64 zone_bottom = a->pos.y;

  Enemy *e_temp = slug_que.next;
  while(e_temp != &slug_que)
  {
    Enemy *e_next = e_temp->next;
    if(e_temp->myCol->pos.x < zone_right &&
    e_temp->myCol->pos.x + e_temp->myCol->size.x > zone_left &&
    e_temp->myCol->pos.y < zone_bottom &&
    e_temp->myCol->pos.y + e_temp->myCol->size.y > zone_top)
    {
      e_temp->Health = 0;
      e_temp = e_next;
      return TRUE;
    }
    e_temp = e_next;
  }


  Turtle *t_temp = turtle_que.next;
  while(t_temp != &turtle_que)
  {
    Turtle *t_next = t_temp->next;
    if(t_temp->myCol->pos.x < zone_right &&
    t_temp->myCol->pos.x + t_temp->myCol->size.x > zone_left &&
    t_temp->myCol->pos.y < zone_bottom &&
    t_temp->myCol->pos.y + t_temp->myCol->size.y > zone_top)
    {
      KillTurtle(t_temp);
      t_temp = t_next;
      return TRUE;
    }
    t_temp = t_next;
  }

  TShell *ts_temp = tshell_que.next;
  while(ts_temp != &tshell_que)
  {
    TShell *ts_next = ts_temp->next;
    if(ts_temp->myCol->pos.x < zone_right &&
    ts_temp->myCol->pos.x + ts_temp->myCol->size.x > zone_left &&
    ts_temp->myCol->pos.y < zone_bottom &&
    ts_temp->myCol->pos.y + ts_temp->myCol->size.y > zone_top)
    {
      ts_temp->Health = 0;
      ts_temp = ts_next;
      return TRUE;
    }
    ts_temp = ts_next;
  }

  e_temp = shroom_que.next;
  while(e_temp != &shroom_que)
  {
    e_next = e_temp->next;
    if(e_temp->myCol->pos.x < zone_right &&
    e_temp->myCol->pos.x + e_temp->myCol->size.x > zone_left &&
    e_temp->myCol->pos.y < zone_bottom &&
    e_temp->myCol->pos.y + e_temp->myCol->size.y > zone_top)
    {
      e_temp->vel.y = -5;
      e_temp->isLookingRight = !e_temp->isLookingRight;
      return TRUE;
    }
    e_temp = e_next;
  }


  // Coin
  Coin *coin_temp = coin_que.next;
  while(coin_temp != &coin_que)
  {
    Coin *coin_next = coin_temp->next;
    if(coin_temp->myCol->pos.x < zone_right &&
    coin_temp->myCol->pos.x + coin_temp->myCol->size.x > zone_left &&
    coin_temp->myCol->pos.y < zone_bottom &&
    coin_temp->myCol->pos.y + coin_temp->myCol->size.y > zone_top)
    {
      plr.coins++;
      NewQuestionPart(
      coin_temp->myCol->pos.x,
      coin_temp->myCol->pos.y,
      tex_Particle_Coin1);
      DelCoin(coin_temp);
      return TRUE; 
    }
    coin_temp = coin_next;    
  }


  return FALSE;
}


U0 ShootFireball()
{
  if(QueCnt(&fireball_que) >= 2)
  {
    return;
  }
  if(plr.powerUp != 2)
    return;
  if(keys.space)
  {
    NewFireball(plr.myCollider->pos.x, plr.myCollider->pos.y, plr.isLookingRight);
    keys.space = FALSE;
  }
}