Cd(__DIR__);;
#include "SpriteLoad.HC";
#include "Globals.HC";
#include "Actions.HC";
#include "Update.HC";
#include "Draw.HC";


// incase someone has custom theme on
public CBGR48 gr_palette_std_a[COLORS_NUM]={
0x000000000000,0x00000000AAAA,0x0000AAAA0000,0x0000AAAAAAAA,
0xAAAA00000000,0xAAAA0000AAAA,0xAAAA55550000,0xAAAAAAAAAAAA,
0x555555555555,0x55555555FFFF,0x5555FFFF5555,0x5555FFFFFFFF,
0xFFFF55555555,0xFFFF5555FFFF,0xFFFFFFFF5555,0xFFFFFFFFFFFF};

GrPaletteSet(gr_palette_std_a);

U0 CleanUp()
{
  // Free all the queues and stuff
  CleanUpQueues;
}

U0 DrawIt(CTask *task, CDC *dc)
{
  DCFill(dc, BLACK);

  DrawSky(dc);
  UpdatePauseTimer;
  UpdatePlayerImmune;
  if(!g_Paused)
  {
    UpdateFireballs;
    ShootFireball;
    UpdatePlrMove;
    UpdateBreakables;
    UpdateQuestions;
    UpdateQuestionParts;
    UpdateCam;
    UpdateSlugs;
    UpdateTShells;
    UpdateTurtles;
    UpdateShrooms;
    UpdateFlowers;
    UpdateCoins;
    UpdatePlatforms;
    UpdateParticles;
    UpdateEndLevels;    
  }
  UpdateMousePos;


//  DrawColliders(dc);
  DrawMap(dc);
  DrawQuestionParts(dc);
  DrawBricks(dc);
  DrawQuestions(dc);
  DrawSlugs(dc);  
  DrawTurtles(dc);
  DrawTShells(dc);
  DrawShrooms(dc);
  DrawFlowers(dc);
  UpdatePlayerAnimation;
  
  DrawCoins(dc);
  DrawEndLevels(dc);
  DrawPlayer(dc);
  DrawParticles(dc);
  DrawFireballs(dc);
  DrawPlatforms(dc);


  DrawEndFadeIn(dc);
  dc->color = WHITE;
  GrPrint(dc,76, 24, "PlumberMan");
  GrPrint(dc,76, 34, "000000");

  GrPrint(dc, 200, 34, "Coins: %d",plr.coins);

  GrPrint(dc, 376, 24, "World");
  GrPrint(dc, 376, 34, "1-%d",g_currentLevel);

  GrPrint(dc, 520, 24, "Time");
  GrPrint(dc, 520, 34, "300");
  
}

U0 Main()
{
  DocClear;
  WinMax;
  SettingsPush;
  AutoComplete;
  WinBorder;
  DocCursor;
  Fs->draw_it = &DrawIt;
  I64 input1, input2;

  while(g_Gaming)
  {
      
      switch(GetMsg(&input1, &input2, 1<<MSG_KEY_DOWN+1<<MSG_KEY_UP))
      {
	case MSG_KEY_UP:
	  switch(input1)
          {
	    case CH_SHIFT_ESC: g_Gaming = FALSE; break;
	    case CH_SPACE: case CH_SHIFT_SPACE: keys.space = FALSE; break;
            case 'w': case 'W': keys.up = FALSE; break;
	    case 's': case 'S': keys.down = FALSE; break;
	    case 'a': case 'A': keys.left = FALSE; break;
	    case 'd': case 'D': keys.right = FALSE; break;
	    case 0:

	      switch(input2.u8[0])$IV,0$
	      {
		case '\n':
		  // do nothing
                break;
		case SC_CURSOR_UP: keys.up = FALSE; break;
		case SC_CURSOR_DOWN: keys.down = FALSE; break;
		case SC_CURSOR_LEFT: keys.left = FALSE; break;
		case SC_CURSOR_RIGHT: keys.right = FALSE; break;
		case SC_SHIFT: keys.shift = FALSE; break;
	      }

	    break;
	  }
	break;

	case MSG_KEY_DOWN:
	  switch(input1)
          {
	      case CH_SPACE: case CH_SHIFT_SPACE: keys.space = TRUE; break;
	      case CH_ESC: g_Gaming = FALSE; break;
	      case 'w': case 'W': keys.up = TRUE; break;
	      case 's': case 'S': keys.down = TRUE; break;
	      case 'a': case 'A': keys.left = TRUE; break;
	      case 'd': case 'D': keys.right = TRUE; break;
	      case 0:

	      switch(input2.u8[0])
	      {
		case '\n':
		  // do nothing
                break;
		case SC_CURSOR_UP: keys.up = TRUE; break;
		case SC_CURSOR_DOWN: keys.down = TRUE; break;
		case SC_CURSOR_LEFT: keys.left = TRUE; break;
		case SC_CURSOR_RIGHT: keys.right = TRUE; break;
		case SC_SHIFT: keys.shift = TRUE; break;
	      }

	    break;
	  }
	break;

      }
  }
  CleanUp;
  SettingsPop;
  GrPaletteSet(gr_palette_std);
}

Main;