#define PLR_COLLIDER 1
#define WALL_COLLIDER 2
#define BULLET_COLLIDER 3
#define ENEMY_COLLIDER 4
#define TSHELL_COLLIDER 5
#define SHROOM_COLLIDER 6
#define BREAKABLE_COLLIDER 7
#define QUESTION_COLLIDER 8
#define COIN_COLLIDER 9
#define FLOWER_COLLIDER 10
#define FIREBALL_COLLIDER 11
#define ENDLEVEL_COLLIDER 12
#define PLATFORM_COLLIDER 13
#define BOUNCEOFF_COLLIDER 14

#define GRAVITY 1
#define FRICTION 1.3

#define MAP_WIDTH 1
#define MAP_HEIGHT 20

#define PLR_BIG_SIZE_Y 40

#define PI 3.14159265359

Bool g_Gaming = TRUE;

Bool g_Paused = FALSE;

F64 dT = 0;
F64 lastTime = tS;
F64 dtScale;

class Vector2
{
  F64 x,y;
};

class Collider : CQue
{
  Vector2 pos;
  Vector2 size;
  I64 type;
} collider_que;

class Player
{
  Collider *headCol;
  Collider *myCollider;
  Collider *footCol;
  CDC *curSprite;
  Vector2 vel;
  Bool grounded;
  Bool isWalking;
  Bool isJumping;
  Bool isFalling;
  Bool isLookingRight;
  Bool isFinished;
  F64 gravity;
  F64 acceleration;
  I8 powerUp;
  I8 walkFrame;
  I64 walk_frameSpeed;
  I64 walk_frameSpeedReset;
  F64 endlevel_Timer;

  Bool ducking;

  Bool immune;
  Bool immuneFlash;
  I8 immuneTimer;
  I8 immuneCycles;

  I8 pauseTimer;

  I64 coins;
  I64 score;
} plr;


// i actually never used this feature idk why i added this
class PlayerColStatus
{
  Bool isColBottom;
  Bool isColTop;
  Bool isColLeft;
  Bool isColRight;  
} plrCol;

class Keys
{
  Bool up,down,left,right,space,shift;
} keys;

class Bullet : CQue
{
  Vector2 vel;
  Collider *myCollider;
} bullet_que;

class Map
{
  I64 *mapArray;
  I64 *entityArray;
  I64 width;
  I64 height;
} current_map;

class Enemy : CQue
{
  Collider *myCol;
  Vector2 vel;
  I64 Health;
  Bool active;
  Bool grounded;
  Bool isLookingRight;
  F64 speed;
  CDC *curSprite;
};

class Slug : Enemy
{
  F64 walk_frameSpeed;
  I64 curFrame;

} slug_que;

class Turtle : Enemy
{
  F64 walk_frameSpeed;
  I64 curFrame;
} turtle_que;

class TShell : Enemy
{
  
} tshell_que;

class Shroom : Enemy
{

} shroom_que;

class Particle : CQue
{
  Vector2 pos;
  Vector2 vel;
  CDC *curSprite;
} particle_que;

class Breakable : CQue
{
  Collider *myCol;
  CDC *curSprite;
  Bool isFalling;
  F64 offsetY;
};

class Brick : Breakable
{

} brick_que;

class QuestionBlock : CQue
{
  Collider *myCol;
  I64 amount;
  Bool isPowerUp;
  CDC *curSprite;
  Bool isFalling;
  F64 offsetY;
  F64 glowTimer;
  Bool glowing;
  Bool hidden;
} question_que;

class QuestionPart : CQue
{
  Vector2 pos;
  CDC *curSprite;
  I64 curFrame;
  F64 frameTimer;
  F64 timerReset;
  F64 offsetY;
  I8 type;
  Bool isFalling;
} questionpart_que;

class Coin : CQue
{
  Collider *myCol;
  CDC *curSprite;
  Bool glowing;
  F64 glowingTimer;
} coin_que; 

class Flower : Coin
{
} flower_que;

class Fireball : CQue
{
  Collider *myCol;
  Vector2 vel;
  CDC *curSprite;
  I8 curFrame;
  F64 frameTimer;
  Bool grounded;
  Bool delete;
} fireball_que;

class EndLevel : CQue
{
  Collider *myCol;
  Collider *endCol;
  Vector2 pos;
  F64 yOffset;
  Bool bounceDown;
} endlevel_que;

class Platform : CQue
{
  Collider *myCol;
  Vector2 vel;
  Vector2 previousPos;
  I64 type;
  F64 timer;
  Bool falling;
} platform_que;

class BounceOff : CQue
{
  Collider *myCol;
} bounceoff_que;

class SpinLaser : CQue
{
  Collider *myCol;
  Collider *killCol;
  F64 deg;
} spinlaser_que;

I8 g_currentLevel = 1;

QuestionPart *NewQuestionPart(F64 x, F64 y, CDC *sprite, I64 timerReset = 1, I8 type = 1)
{
  QuestionPart *new = CAlloc(sizeof(QuestionPart));
  new->pos.x = x;
  new->pos.y = y;
  new->timerReset = timerReset;
  new->curFrame = 1;
  new->frameTimer = 0;
  new->curSprite = sprite;
  new->offsetY = 0;
  new->type = type;
  new->isFalling = FALSE;
  QueIns(new, questionpart_que);
  return new;
}

U0 DelQuestionPart(QuestionPart *a)
{
  QueRem(a);
  Free(a);
}

Collider *NewCollider(F64 x1, F64 y1, F64 x2, F64 y2, F64 type)
{
  Collider *new = CAlloc(sizeof(Collider));
  new->pos.x = x1;
  new->pos.y = y1;
  new->size.x = x2;
  new->size.y = y2;
  new->type = type;
  QueIns(new, collider_que);
  return new;
}

U0 DelCollider(Collider *a)
{
  QueRem(a);
  Free(a);
}

SpinLaser *NewSpinLaser(F64 x, F64 y)
{
  SpinLaser *new = CAlloc(sizeof(SpinLaser));
  new->deg = 0;
  new->myCol = NewCollider(x, y, 24, 24, WALL_COLLIDER);
  new->killCol = NewCollider(x, y - 100, 24, 24, WALL_COLLIDER);
  QueIns(new, spinlaser_que);
  return new;
}

BounceOff *NewBounceOff(F64 x, F64 y)
{
  BounceOff *new = CAlloc(sizeof(BounceOff));
  new->myCol = NewCollider(x, y, 24, 24, BOUNCEOFF_COLLIDER);
  QueIns(new, bounceoff_que);
  return new;
}

U0 DelBounceOff(BounceOff *a)
{
  DelCollider(a->myCol);
  QueRem(a);
  Free(a);
}


Slug *NewSlug(F64 x, F64 y)
{
  Slug *new = CAlloc(sizeof(Slug));
  new->myCol = NewCollider(x, y, 24, 12, ENEMY_COLLIDER);
  new->vel.x = 0;
  new->vel.y = 0;
  new->active = FALSE;
  new->grounded = FALSE;
  new->isLookingRight = FALSE;
  new->curSprite = tex_Slug_Walk1Left;
  new->walk_frameSpeed = 3;
  new->curFrame = 1;
  new->speed = 2;
  new->Health = 1;
  QueIns(new, slug_que);
  return new;
}

U0 DelSlug(Slug *a)
{
  DelCollider(a->myCol);
  QueRem(a);
  Free(a);
}

Turtle *NewTurtle(F64 x, F64 y)
{
  Turtle *new = CAlloc(sizeof(Turtle));
  new->myCol = NewCollider(x, y, 22, 12, ENEMY_COLLIDER);
  new->vel.x = 0;
  new->active = FALSE;
  new->vel.y = 0;
  new->Health = 1;
  new->grounded = FALSE;
  new->isLookingRight = FALSE;
  new->curSprite = tex_Turtle_Walk1Left;
  new->walk_frameSpeed = 5;
  new->curFrame = 1;
  new->speed = 1.5;
  QueIns(new, turtle_que);
  return new;
}

U0 DelTurtle(Turtle *a)
{
  DelCollider(a->myCol);
  QueRem(a);
  Free(a);
}


TShell *NewTShell(F64 x, F64 y, Bool isLookingRight)
{
  TShell *new = CAlloc(sizeof(TShell));
  new->myCol = NewCollider(x, y, 15, 9, TSHELL_COLLIDER);
  new->Health = 1;
  new->curSprite = tex_Turtle_Shell;
  new->vel.x = 0;
  new->active = FALSE;
  new->vel.y = 0;
  new->grounded = FALSE;
  new->isLookingRight = isLookingRight;
  new->speed = 5;
  QueIns(new, tshell_que);
  return new;
}

U0 DelTShell(TShell *a)
{
  DelCollider(a->myCol);
  QueRem(a);
  Free(a);
}

Shroom *NewShroom(F64 x, F64 y)
{
  Shroom *new = CAlloc(sizeof(Shroom));
  new->myCol = NewCollider(x,y,24,24, SHROOM_COLLIDER);
  new->Health = 1;
  new->curSprite = tex_Powerup_Shroom;
  new->active = FALSE;
  new->isLookingRight = TRUE;
  new->speed = 2;
  QueIns(new, shroom_que);
  return new;
} 

U0 DelShroom(Shroom *a)
{
  DelCollider(a->myCol);
  QueRem(a);
  Free(a);
}

Brick *NewBrick(F64 x, F64 y)
{
  Brick *new = CAlloc(sizeof(Brick));
  new->myCol = NewCollider(x,y,24,24, BREAKABLE_COLLIDER);
  new->isFalling = FALSE;
  new->offsetY = 0;
  new->curSprite = tex_Brick;
  QueIns(new, brick_que);
  return new;
}

U0 DelBrick(Brick *a)
{
  DelCollider(a->myCol);
  QueRem(a);
  Free(a);
}

QuestionBlock *NewQuestion(F64 x, F64 y, I64 amount = 1, Bool hidden = FALSE, Bool powerUp = FALSE)
{
  QuestionBlock *new = CAlloc(sizeof(QuestionBlock));
  new->myCol = NewCollider(x, y, 24, 24, QUESTION_COLLIDER);
  new->isFalling = FALSE;
  new->offsetY = 0;
  new->amount = amount;
  new->hidden = hidden;
  new->isPowerUp = powerUp;
  new->curSprite = tex_Question1;
  QueIns(new, question_que);
  return new;
}

U0 DelQuestion(QuestionBlock *a)
{
  DelCollider(a->myCol);
  QueRem(a);
  Free(a);
}

Particle *NewParticle(F64 x, F64 y, CDC *sprite, F64 velX = 0, F64 velY = 0)
{
  Particle *new = CAlloc(sizeof(Particle));
  new->pos.x = x;
  new->pos.y = y;
  new->vel.x = velX;
  new->vel.y = velY;
  new->curSprite = sprite;
  QueIns(new, particle_que.last);
  return new;
}

U0 DelParticle(Particle *a)
{
  QueRem(a);
  Free(a);
}

Coin *NewCoin(F64 x, F64 y)
{
  Coin *new = CAlloc(sizeof(Coin));
  new->myCol = NewCollider(x,y,24,24,COIN_COLLIDER);
  new->curSprite = tex_Coin1;
  QueIns(new, coin_que.last);
  return new;
}

U0 DelCoin(Coin *a)
{
  DelCollider(a->myCol);
  QueRem(a);
  Free(a);
}

Flower *NewFlower(F64 x, F64 y)
{
  Flower *new = CAlloc(sizeof(Flower));
  new->myCol = NewCollider(x,y,24,24,FLOWER_COLLIDER);
  new->curSprite = tex_Powerup_Flower1;
  QueIns(new, flower_que.last);
  return new;
}

U0 DelFlower(Flower *a)
{
  DelCollider(a->myCol);
  QueRem(a);
  Free(a);
}

Fireball *NewFireball(F64 x, F64 y, Bool isLookingRight = TRUE;)
{
  Fireball *new = CAlloc(sizeof(Fireball));
  new->curSprite = tex_Fireball1;
  new->delete = FALSE;
  new->frameTimer = 0;
  if(isLookingRight)
    new->vel.x = 8;
  else
    new->vel.x = -8;
  new->myCol = NewCollider(x, y, 12, 12, FIREBALL_COLLIDER);
  QueIns(new, fireball_que.last);
  return new;
}

U0 DelFireball(Fireball *a)
{
  if(!a)
    return;
  DelCollider(a->myCol);
  QueRem(a);
  Free(a);
}

EndLevel *NewEndLevel(F64 x, F64 y)
{
  EndLevel *new = CAlloc(sizeof(EndLevel));
  new->pos.x = x;
  new->pos.y = y;
  new->myCol = NewCollider(x, y, 48, 12, ENDLEVEL_COLLIDER);
  new->endCol = NewCollider(x - 24, 0, 8, 480, ENDLEVEL_COLLIDER);
  new->yOffset = 0;
  new->bounceDown = TRUE;
  QueIns(new, endlevel_que.last);
  return new;
}

U0 DelEndLevel(EndLevel *a)
{
  DelCollider(a->myCol);
  QueRem(a);
  Free(a);
}

U0 KillTurtle(Turtle *a)
{
  NewParticle(a->myCol->pos.x, a->myCol->pos.y, tex_Turtle_Shell);
  DelTurtle(a); 
}

Platform *NewPlatform(F64 x, F64 y, I64 type = 1)
{
  Platform *new = CAlloc(sizeof(Platform));
  new->myCol = NewCollider(x, y, 48, 8, PLATFORM_COLLIDER);
  new->vel.x = 0;
  new->vel.y = 0;
  new->type = type;
  new->falling = FALSE;
  QueIns(new, platform_que);
  return new;
}

U0 DelPlatform(Platform *a)
{
  DelCollider(a->myCol);
  QueRem(a);
  Free(a);
}

Bool AABBCollision(Collider *a, Collider *b)
{
  if(a->pos.x >= b->pos.x + b->size.x) return FALSE;
  if(a->pos.x + a->size.x <= b->pos.x) return FALSE;
  if(a->pos.y >= b->pos.y + b->size.y) return FALSE;
  if(a->pos.y + a->size.y <= b->pos.y) return FALSE;
  return TRUE;
}

Bool isColliderPlayer(Collider *a)
{
  if(a == plr.myCollider)
  {
    return TRUE;
  }

  if(a == plr.headCol)
  {
    return TRUE;
  }

  if(a == plr.footCol)
  {
    return TRUE;
  }
  return FALSE;
}


Bool isAbovePlayer()
{
  Collider *temp = collider_que.next;
  while(temp != &collider_que)
  {
    Collider *next = temp->next;
    Bool amIPlr = isColliderPlayer(temp);
    if(amIPlr)
    {
      goto cont;
    }
    if(AABBCollision(plr.headCol, temp))
    {
      return TRUE;
    }
    cont:
    temp = next;
  }
  return FALSE;
}


Vector2 camOffset;

U0 InitMapEntities()
{
  if(current_map.entityArray == NULL)
  {
    return;
  }
  I64 x,y = 0;
  for(y=0;y<current_map.height;y++)
  {
    for(x=0;x<current_map.width;x++)
    {
      I64 tile = current_map.entityArray[x + y * current_map.width];
      switch(tile)
      {
	case 1: NewCollider(x*24,y*24,24,24,2); break;
        case 2: 
	  plr.myCollider->pos.x = x * 24 + 6;
	  plr.myCollider->pos.y = y * 24;
	break;
        case 3: NewSlug(x*24,y*24 + 12); break;
	case 4: NewTurtle(x*24,y*24 + 12); break;
	case 5: NewShroom(x*24,y*24); break;
	case 6: NewBrick(x*24,y*24); break;
	case 7: NewQuestion(x*24, y*24); break;
	case 8: NewQuestion(x*24, y*24, 10, TRUE); break;
	case 9: NewQuestion(x*24, y*24,,,TRUE); break;
	case 10: NewCoin(x*24, y*24); break;
	case 11: NewEndLevel(x*24, y*24); break;
	case 12: NewPlatform(x*24, y*24); break;
	case 13: NewBounceOff(x*24, y *24); break;
	case 14: NewPlatform(x*24, y*24, 2); break;
	case 15: NewSpinLaser(x * 24, y * 24); break;
      }
    }
  }
}

I64 g_MouseX = ms.pos.x;
I64 g_MouseY = ms.pos.y;

F64 FixDeg(I64 deg)
{
  if(deg > 359)
  {
    deg -= 360;
  }
  if(deg < 0)
  {
    deg += 360;
  }
  return deg;
}

F64 Deg2Rad(I64 deg)
{
  F64 rad = ToF64(deg) * (PI/180);
  return rad;
}


U0 LoadMap(U8 *file)
{
  // stupid easy fix 
  Cd(__DIR__);;
  U8 *buffer = FileRead(file);
  if(buffer == NULL)
  {
    return;
  }
  U8 *ptr = buffer;

  I64 width = Str2I64(ptr, 10 , &ptr);
  ptr++;
  I64 height = Str2I64(ptr, 10, &ptr);


  I64 *mapArray = MAlloc(width * height * sizeof(I64));
  I64 *entityArray = MAlloc(width * height * sizeof(I64));
  I64 x, y;
  for(y=0;y<height;y++)
  {
    for(x=0;x<width;x++)
    {
      while(*ptr && (*ptr == ' ' || *ptr == '\t' || *ptr == '\n' || *ptr == '\r'))
      {
        ptr++;
      }
      mapArray[x + y * width] = Str2I64(ptr, 10, &ptr);
    }
  }

  for(y=0;y<height;y++)
  {
    for(x=0;x<width;x++)
    {
      while(*ptr == ' ' || *ptr == '\n' || *ptr == '\r') ptr++;
      entityArray[x + y * width] = Str2I64(ptr, 10, &ptr);
    }
  }

  current_map.mapArray = mapArray;
  current_map.entityArray = entityArray;
  current_map.width = width;
  current_map.height = height;
}


U0 PlayerPowerUp(Bool shroom = TRUE)
{
  if(plr.powerUp == 1 && shroom)
    return;

  if(plr.powerUp == 1)
  {
    g_Paused = TRUE;
    plr.immune = TRUE;
    plr.powerUp = 2;    
  }

  if(plr.powerUp == 2)
  {
    return;
  }

  g_Paused = TRUE;
  plr.immune = TRUE;
  plr.powerUp = 1;
  
  Bool isAbove = isAbovePlayer;
  F64 oldSizeY = plr.myCollider->size.y;
  plr.myCollider->size.y = PLR_BIG_SIZE_Y;
  F64 newSizeY = plr.myCollider->size.y;
  plr.myCollider->pos.y -= newSizeY - oldSizeY;
  if(isAbove)
  {
    plr.ducking = TRUE;
  }

}


F64 Lerp(F64 a, F64 b, F64 t)
{
  return a + t * (b - a);
}

U0 CleanUpMap()
{
  if(current_map.mapArray)
  {
    Free(current_map.mapArray);
    current_map.mapArray = NULL;
  }
  if(current_map.entityArray)
  {
    Free(current_map.entityArray);
    current_map.entityArray = NULL;
  }
  current_map.width = 0;
  current_map.height = 0;
}

U0 CleanUpQueues()
{
  QueDel(&collider_que);
  QueDel(&slug_que);
  QueDel(&particle_que);
  QueDel(&turtle_que);
  QueDel(&tshell_que);
  QueDel(&shroom_que);
  QueDel(&brick_que);
  QueDel(&question_que);
  QueDel(&questionpart_que);
  QueDel(&coin_que);
  QueDel(&flower_que);
  QueDel(&fireball_que);
  QueDel(&endlevel_que);
  QueDel(&platform_que);
  QueDel(&bounceoff_que);
}

U0 LoadLevel()
{

  switch(g_currentLevel)
  {
    default: LoadMap("Maps/Test.TXT"); break;
    case 1: LoadMap("Maps/City.TXT"); break;
    case 2: LoadMap("Maps/Sewers.TXT"); break;
    case 3: LoadMap("Maps/Rooftops.TXT"); break;
  }
}

U0 Init(Bool keepData = FALSE)
{

/*  current_map.mapArray = &gameMap;
  current_map.width = 20;
  current_map.height = MAP_HEIGHT; */
//LoadMap("Maps/Test1.TXT");
  g_currentLevel = 4;
  CleanUpMap;
  LoadLevel;
  QueInit(&collider_que);
  QueInit(&particle_que);
  QueInit(&slug_que);
  QueInit(&turtle_que);
  QueInit(&tshell_que);
  QueInit(&shroom_que);
  QueInit(&brick_que);
  QueInit(&question_que);
  QueInit(&questionpart_que);
  QueInit(&coin_que);
  QueInit(&flower_que);
  QueInit(&fireball_que);
  QueInit(&endlevel_que);
  QueInit(&platform_que);
  QueInit(&bounceoff_que);
  QueInit(&spinlaser_que);
  
  plr.headCol = NewCollider(0,-10, 12, 20, 1);
  plr.myCollider = NewCollider(0, 0, 12, 22, 1);
  plr.footCol = NewCollider(2, 22, 10, 6, 1); 
  plr.vel.x = 0;
  plr.vel.y = 0;
  plr.acceleration = 1.3;
  plr.gravity = 1;
  plr.curSprite = tex_PMan_IdleRight;
  plr.walk_frameSpeed = 5;
  plr.walk_frameSpeedReset = 5;
  plr.isLookingRight = TRUE;
  plr.grounded = FALSE;
  plr.isJumping = TRUE;
  // Flashing sprite, not actual immune timer
  plr.immuneTimer = 0;
  plr.immune = FALSE;
  if(!keepData)
  {
    plr.powerUp = 0;
  }
  plr.isFinished = FALSE;
  plr.endlevel_Timer = 0;

  plr.pauseTimer = 15;

  plrCol.isColBottom = FALSE;
  plrCol.isColTop = FALSE;
  plrCol.isColLeft = FALSE;
  plrCol.isColRight = FALSE;

  keys.up = FALSE;
  keys.down = FALSE;
  keys.left = FALSE;
  keys.right = FALSE;
  keys.space = FALSE;
  
  InitMapEntities;
}

U0 UnitsSec(F64 val)
{
  return val * 30.0;
}

U0 PlayerDie()
{
  if(plr.isFinished)
  {
    return;
  }
  if(plr.myCollider->pos.y > 500)
  {
    goto cont;
  }
  if(plr.immune)
  {
    return;
  }
  if(plr.powerUp != 0)
  {
    plr.immune = TRUE;
    g_Paused = TRUE;
    plr.powerUp = 0;
    F64 oldSizeY = plr.myCollider->size.y;
    plr.myCollider->size.y = 22;
    F64 newSizeY = plr.myCollider->size.y;
    plr.myCollider->pos.y -= newSizeY - oldSizeY;
    return;
  }
  cont:
  CleanUpQueues;
  
  Init;
}

Init;


