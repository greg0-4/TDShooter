
U0 DrawSky(CDC *dc)
{
  if((g_currentLevel % 2) == 0)
  {
    dc->color = BLACK;
    GrRect(dc,0,0,640,480);
    return;
  }
  dc->dither_probability_u16=1;
  dc->color=ROPF_DITHER+LTBLUE<<16+WHITE;
  GrRect3(dc,0,0,0,640,480);
  GrBlot(dc, 500, 50, tex_Sun);
  GrBlot(dc, 100, 100, tex_Cloud);
  GrBlot(dc, 120, 105, tex_Cloud);
  GrBlot(dc, 220, 100, tex_Cloud);
  GrBlot(dc, 300, 90, tex_Cloud);
  GrBlot(dc, 320, 100, tex_Cloud);
  dc->color = BLACK;
}

U0 DrawColliders(CDC *dc)
{
dc->color=ROPF_DITHER+GREEN<<16+TRANSPARENT;
  Collider *temp = collider_que.next;
  while(temp != &collider_que)
  {
    Collider *next = temp->next;
    GrRect(dc, temp->pos.x - camOffset.x, temp->pos.y - camOffset.y, temp->size.x, temp->size.y);
    temp = next; 
  }
  dc->color = BLACK;
}


U0 DrawMap(CDC *dc)
{
  dc->color = BLACK;
  if(current_map.mapArray == NULL)
  {
    return;
  }
  I64 x, y;
  for(x=0;x<current_map.width;x++)
  {
    for(y=0;y<current_map.height;y++)
    {
      I64 tile = current_map.mapArray[x + y * current_map.width];
      I64 posX = (x * 24) - camOffset.x;
      I64 posY = (y * 24) - camOffset.y;
      if(posX < -26)
      {
        break;
      }
      if(posX > 650)
      {
	break;
      }
      switch(tile)
      {

	case 1: GrBlot(dc, posX, posY, tex_Tile); break;
        case 2: GrBlot(dc, posX, posY, tex_BrickWall); break;
	case 3: GrBlot(dc, posX, posY, tex_BrickWall_Door); break;
	case 4: GrBlot(dc, posX, posY, tex_BrickWall_Window); break;
	case 5: GrBlot(dc, posX, posY, tex_BrickWall_Roof); break;
	case 6: GrBlot(dc, posX, posY, tex_Tile_Road_Left); break;
	case 7: GrBlot(dc, posX, posY, tex_Tile_Road); break;
	case 8: GrBlot(dc, posX, posY, tex_Tile_Road_Right); break;
	case 9: GrBlot(dc, posX, posY, tex_Tile_Road_Hole); break;
	case 10: GrBlot(dc, posX, posY, tex_Tile_Road_Hole_Open); break;
	case 11: GrBlot(dc, posX, posY, tex_BrickHole_TL); break;
	case 12: GrBlot(dc, posX, posY, tex_BrickHole_TR); break;
	case 13: GrBlot(dc, posX, posY, tex_BrickHole_BL); break;
	case 14: GrBlot(dc, posX, posY, tex_BrickHole_BR); break;
	case 15: GrBlot(dc, posX, posY, tex_BrickWall_WaterL); break;
	case 16: GrBlot(dc, posX, posY, tex_BrickWall_WaterR); break;
        case 17: GrBlot(dc, posX, posY, tex_Tile_Water_Left); break;
	case 18: GrBlot(dc, posX, posY, tex_Tile_Water); break;
	case 19: GrBlot(dc, posX, posY, tex_Tile_Water_Right); break;
	case 20: GrBlot(dc, posX, posY, tex_Tile_Sewer); break;
	case 21: GrBlot(dc, posX, posY, tex_Mansion_Wall_Top); break;
	case 22: GrBlot(dc, posX, posY, tex_Mansion_Wall); break;
	case 23: GrBlot(dc, posX, posY, tex_Mansion_Wall_Down); break;
	case 24: GrBlot(dc, posX, posY, tex_MansionWall_Window_TL); break;
	case 25: GrBlot(dc, posX, posY, tex_MansionWall_Window_TR); break;
	case 26: GrBlot(dc, posX, posY, tex_MansionWall_Window_BL); break;
	case 27: GrBlot(dc, posX, posY, tex_MansionWall_Window_BR); break;
	case 28: GrBlot(dc, posX, posY, tex_MansionWall_Entrance_BL); break;
	case 29: GrBlot(dc, posX, posY, tex_MansionWall_Entrance_BR); break;
	case 30: GrBlot(dc, posX, posY, tex_MansionWall_Entrance_TL); break;
	case 31: GrBlot(dc, posX, posY, tex_MansionWall_Entrance_TR); break;
	case 32: GrBlot(dc, posX, posY, tex_MansionTemple_PillarUp); break;
	case 33: GrBlot(dc, posX, posY, tex_MansionTemple_Pillar); break;
	case 34: GrBlot(dc, posX, posY, tex_MansionTemple_PillarDown); break;
	case 35: GrBlot(dc, posX, posY, tex_MansionTemple_Roof1Left); break;
	case 36: GrBlot(dc, posX, posY, tex_MansionTemple_Roof1Right); break;
	case 37: GrBlot(dc, posX, posY, tex_MansionTemple_Roof2Left); break;
	case 38: GrBlot(dc, posX, posY, tex_MansionTemple_Roof2Right); break;
	case 39: GrBlot(dc, posX, posY, tex_MansionTemple_StatueTL); break;
	case 40: GrBlot(dc, posX, posY, tex_MansionTemple_StatueTR); break;
	case 41: GrBlot(dc, posX, posY, tex_MansionTemple_StatueBL); break;
	case 42: GrBlot(dc, posX, posY, tex_MansionTemple_StatueBR); break;
	case 43: GrBlot(dc, posX, posY, tex_Tile_Platform); break;
      }
    }
  }
  dc->color = BLACK;
}

U0 DrawPlayer(CDC *dc)
{
  if(plr.immuneFlash)
  {
    return;
  }

  F64 yOffset = 6;

  F64 yPos = plr.myCollider->pos.y - camOffset.y - 1;
  if(plr.powerUp != 0 && !plr.ducking)
  {
    yPos = yPos - yOffset;
  }

  if(plr.myCollider->size.y == PLR_BIG_SIZE_Y && plr.ducking)
  {
    yPos = plr.myCollider->pos.y + 18;
  }

  GrBlot(dc,
  plr.myCollider->pos.x - camOffset.x - 6,
  yPos,
  plr.curSprite);
}

U0 DrawSlugs(CDC *dc)
{
  Slug *temp = slug_que.next;
  while(temp != &slug_que)
  {
    Slug *next = temp->next;
    I64 posX = (temp->myCol->pos.x) - camOffset.x;
    I64 posY = (temp->myCol->pos.y) - camOffset.y;
    if(posX < -26)
    {
      goto cont;
    }
    if(posX > 650)
    {
      goto cont;
    }
    GrBlot(dc,
    temp->myCol->pos.x - camOffset.x,
    temp->myCol->pos.y - 12 -  camOffset.y,
    temp->curSprite);
    cont:
    temp = next;
    
  }
  
}

U0 DrawParticles(CDC *dc)
{
  Particle *temp = particle_que.next;
  while(temp != &particle_que)
  {
    Particle *next = temp->next;
    GrBlot(dc,
    temp->pos.x - camOffset.x,
    temp->pos.y - camOffset.y,
    temp->curSprite);
    temp = next;
  }
}


U0 DrawTurtles(CDC *dc)
{
  Turtle *temp = turtle_que.next;
  while(temp != &turtle_que)
  {
    Turtle *next = temp->next;
    I64 posX = (temp->myCol->pos.x) - camOffset.x;
    I64 posY = (temp->myCol->pos.y) - camOffset.y;
    if(posX < -26)
    {
      goto cont;
    }
    if(posX > 650)
    {
      goto cont;
    }
    GrBlot(dc,
    temp->myCol->pos.x - camOffset.x,
    temp->myCol->pos.y - camOffset.y - 12,
    temp->curSprite);
    cont:
    temp = next;
  }
}

U0 DrawTShells(CDC *dc)
{
  TShell *temp = tshell_que.next;
  while(temp != &tshell_que)
  {
    TShell *next = temp->next;
    I64 posX = (temp->myCol->pos.x) - camOffset.x;
    I64 posY = (temp->myCol->pos.y) - camOffset.y;
    if(posX < -26)
    {
      goto cont;
    }
    if(posX > 650)
    {
      goto cont;
    }
    GrBlot(dc,
    temp->myCol->pos.x - camOffset.x - 5,
    temp->myCol->pos.y - camOffset.y - 14,
    temp->curSprite);
    cont:
    temp = next;
  }
}

U0 DrawShrooms(CDC *dc)
{
  Shroom *temp = shroom_que.next;
  while(temp != &shroom_que)
  {
    Shroom *next = temp->next;
    I64 posX = (temp->myCol->pos.x) - camOffset.x;
    I64 posY = (temp->myCol->pos.y) - camOffset.y;
    if(posX < -26)
    {
      goto cont;
    }
    if(posX > 650)
    {
      goto cont;
    }
    GrBlot(dc,
    temp->myCol->pos.x - camOffset.x,
    temp->myCol->pos.y - camOffset.y,
    temp->curSprite);
    cont:
    temp = next;
  }
}

U0 DrawBricks(CDC *dc)
{
  Brick *temp = brick_que.next;
  while(temp != &brick_que)
  {
    Brick *next = temp->next;
    I64 posX = (temp->myCol->pos.x) - camOffset.x;
    I64 posY = (temp->myCol->pos.y) - camOffset.y;
    if(posX < -26)
    {
      goto cont;
    }
    if(posX > 650)
    {
      goto cont;
    }
    GrBlot(dc,
    temp->myCol->pos.x - camOffset.x,
    temp->myCol->pos.y - camOffset.y - temp->offsetY,
    temp->curSprite);
    dc->color = BLACK;
    cont:
    temp = next;
  }
}

U0 DrawQuestions(CDC *dc)
{
  QuestionBlock *temp = question_que.next;
  while(temp != &question_que)
  {
    QuestionBlock *next = temp->next;
    I64 posX = (temp->myCol->pos.x) - camOffset.x;
    I64 posY = (temp->myCol->pos.y) - camOffset.y;
    if(posX < -26)
    {
      goto cont;
    }
    if(posX > 650)
    {
      goto cont;
    }
    GrBlot(dc,
    temp->myCol->pos.x - camOffset.x,
    temp->myCol->pos.y - camOffset.y - temp->offsetY,
    temp->curSprite); 
    cont:
    temp = next;
  }
}

U0 DrawQuestionParts(CDC *dc)
{
  QuestionPart *temp = questionpart_que.next;
  while(temp != &questionpart_que)
  {
    QuestionPart *next = temp->next;
    I64 posX = (temp->pos.x) - camOffset.x;
    I64 posY = (temp->pos.y) - camOffset.y;
    if(posX < -26)
    {
      goto cont;
    }
    if(posX > 650)
    {
      goto cont;
    }
    GrBlot(dc,
    posX,
    posY - temp->offsetY,
    temp->curSprite);
    cont:
    temp = next;
  }
}

U0 DrawCoins(CDC *dc)
{
  Coin *temp = coin_que.next;
  while(temp != &coin_que)
  {
    Coin *next = temp->next;
    F64 posX = temp->myCol->pos.x - camOffset.x;
    F64 posY = temp->myCol->pos.y - camOffset.y;
    if(posX < - 26)
      goto cont;
    if(posY > 650)
      goto cont;
    GrBlot(dc,
    posX,
    posY,
    temp->curSprite);
    cont:
    temp = next;
  }
}

U0 DrawFlowers(CDC *dc)
{
  Flower *temp = flower_que.next;
  while(temp != &flower_que)
  {
    Flower *next = temp->next;
    F64 posX = temp->myCol->pos.x - camOffset.x;
    F64 posY = temp->myCol->pos.y - camOffset.y;
    if(posX < - 26)
      goto cont;
    if(posY > 650)
      goto cont;
    GrBlot(dc,
    posX,
    posY,
    temp->curSprite);
    cont:
    temp = next;
     
  }
}

U0 DrawFireballs(CDC *dc)
{
  Fireball *temp = fireball_que.next;
  while(temp != &fireball_que)
  {
    Fireball *next = temp->next;
    F64 posX = temp->myCol->pos.x - camOffset.x;
    F64 posY = temp->myCol->pos.y - camOffset.y;
    GrBlot(dc,
    posX,
    posY,
    temp->curSprite);
    temp = next;
  }
}


U0 DrawEndLevels(CDC *dc)
{
  EndLevel *temp = endlevel_que.next;
  while(temp != &endlevel_que)
  {
    EndLevel *next = temp->next;
    if(temp == NULL)
    {
      goto cont;
    }
    GrBlot(dc,
    temp->pos.x - camOffset.x - 3,
    temp->pos.y - camOffset.y - 48 - 14 - 24,
    tex_EndLevel_Bar);

    if(temp->myCol != NULL)
    {
      F64 posX = temp->myCol->pos.x - camOffset.x;
      F64 posY = temp->myCol->pos.y - camOffset.y;
      if(posX < - 26)
        goto cont;
      if(posY > 650)
        goto cont;


      GrBlot(dc,
      temp->myCol->pos.x - camOffset.x,
      temp->myCol->pos.y - camOffset.y,
      tex_EndLevel_Zoomer);
    }

    GrBlot(dc,
    temp->pos.x - camOffset.x + 36,
    temp->pos.y - camOffset.y - 48 - 14 - 24,
    tex_EndLevel_Bar);
    cont:
    temp = next;
  }
}


U0 DrawEndFadeIn(CDC *dc)
{
  dc->color = BLACK;
  if(plr.endlevel_Timer >= 3.5 * 30)
  {
    GrBlot(dc,
    0, 0,
    tex_FadeIn2);
  }

  if(plr.endlevel_Timer >= 3 * 30)
  {
    GrBlot(dc,
    0,0, tex_FadeIn1);
  }
}

U0 DrawPlatforms(CDC *dc)
{
  Platform *temp = platform_que.next;
  while(temp != &platform_que)
  {
    Platform *next = temp->next;
    F64 posX = temp->myCol->pos.x - camOffset.x;
    F64 posY = temp->myCol->pos.y - camOffset.y;
    if(posX < - 26)
      goto cont;
    if(posY > 650)
      goto cont;
    GrBlot(dc,
    temp->myCol->pos.x - camOffset.x,
    temp->myCol->pos.y - camOffset.y,
    tex_Platform);
    cont:
    temp = next;
  }
}


U0 DrawSpinLasers(CDC *dc)
{

  SpinLaser *temp = spinlaser_que.next;
  while(temp != &spinlaser_que)
  {
    SpinLaser *next = temp->next;
    GrBlot(dc,
    temp->myCol->pos.x - camOffset.x,
    temp->myCol->pos.y - camOffset.y,
    tex_Question3);
    GrBlot(dc,
    temp->killCol->pos.x - camOffset.x,
    temp->killCol->pos.y - camOffset.y,
    tex_SpinLaser_Ball);
    temp = next;
  }

}