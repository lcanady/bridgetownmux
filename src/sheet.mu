&fn.format [v(d.cco)] = 
	[setq(x, u(fn.getstat, %0, %1))]
  [setq(y, u(fn.getstat.temp, %0, %1))]
  [setq(z, if(eq(%qx,%qy),%qx,%qx%(%qy%)))]
  [ljust(
  	%ch[u(fn.statname, edit(%1,_,%b))]%cn, 
    sub(
    	if(%2,%2,25),
      strlen(%qz)
    ),
    %ch%cx.%cn 
  )]
  %ch[if(eq(%qz,0), -,%qz)]%cn

&fn.sheet.bio [v(d.cco)]=
 	[columns(   
    iter(
      u(fn.stats, %0, bio),
      [ljust(%ch[u(fn.capstr, ## )]:%cn, 12)]
      [u(fn.capstr,get(%0/_bio.[edit(##,%b,_)].perm))] ,|,|
    ), div(sub(width(%#),2),1), |
	)]

&fn.sheet.bio [v(d.cco)] = 
  [ljust([ljust(%chFull Name:%cn,15)][get(%0/_bio.full_name.perm)], sub(div(width(%#),2),1))]%b
  [ljust([ljust(%chConcept:%cn,15)][get(%0/_bio.concep.perm)], sub(div(width(%#),2),1))]%R
  [ljust([ljust(%chAge:%cn,15)][get(%0/_bio.age.perm)], sub(div(width(%#),2),1))]%b
  [ljust([ljust(%chAmbition:, 15)]%cn[get(%0/_bio.ambition.perm)], sub(div(width(%#),2),1))]%r
  [ljust([ljust(%chDesire:%cn,15)][get(%0/_bio.desire.perm)], sub(div(width(%#),2),1))]%b
  [ljust([ljust(%chTemplate:%cn,15)][get(%0/_bio.template.perm)], sub(div(width(%#),2),1))]%b
  

&fn.sheet.bio.vampire [v(d.cco)] = 
  [ljust([ljust(%chFull Name:%cn,15)][get(%0/_bio.full_name.perm)], sub(div(width(%#),2),1))]%b
  [ljust([ljust(%chConcept:%cn,15)][get(%0/_bio.concep.perm)], sub(div(width(%#),2),1))]%R
  [ljust([ljust(%chAge:%cn,15)][get(%0/_bio.age.perm)], sub(div(width(%#),2),1))]%b
  [ljust([ljust(%chPredator:%cn,15)][get(%0/_bio.predator.perm)], sub(div(width(%#),2),1))]%r
  [ljust([ljust(%chSire:%cn,15)][get(%0/_bio.Sire.perm)], sub(div(width(%#),2),1))]%b
  [ljust([ljust(%chAmbition:, 15)]%cn[get(%0/_bio.ambition.perm)], sub(div(width(%#),2),1))]%r
  [ljust([ljust(%chDesire:%cn,15)][get(%0/_bio.desire.perm)], sub(div(width(%#),2),1))]%b
  [ljust([ljust(%chGeneration:%cn,15)][get(%0/_bio.Generation.perm)], sub(div(width(%#),2),1))]%r
  [ljust([ljust(%chTemplate:%cn,15)][get(%0/_bio.Template.perm)], sub(div(width(%#),2),1))]%r 

/*
=============================================================================
===== fn.sheet.stata ========================================================

display a stat sheet for a character

registers:
%0: character
-----------------------------------------------------------------------------
*/

&fn.sheet.stats [v(d.cco)]=
	[center(%b%chAttributes%cn%b, width(%#), - )]%r
  [center(Physical, setr(0, div(width(%#),3)))]
  [center(Social,   %q0)]
  [center(Mental,   %q0)]%r
  [ulocal(fn.format, %0, strength, %q0 )]%b
  [ulocal(fn.format, %0, charisma, sub(%q0,1) )]%b
  [ulocal(fn.format, %0, intelligence, %q0 )]%r
  [ulocal(fn.format, %0, dexterity, %q0 )]%b
  [ulocal(fn.format, %0, manipulation, sub(%q0,1) )]%b
  [ulocal(fn.format, %0, wits, %q0 )]%r
  [ulocal(fn.format, %0, stamina, %q0 )]%b
  [ulocal(fn.format, %0, composure, sub(%q0,1) )]%b
  [ulocal(fn.format, %0, resolve, %q0)]

/*
=============================================================================
===== fn.sheet.stata ========================================================

display a stat sheet for a character

registers:
%0: character
----------------------------------------------------------------------------
*/

&fn.sheet.skills [v(d.cco)]=
    [setq(0,ulocal(fn.sheet.buildskills, %0, physical, div(width(%#),3) ))]
    [setq(1,ulocal(fn.sheet.buildskills, %0, social,  sub(div(width(%#),3), 1) ))]
    [setq(2,ulocal(fn.sheet.buildskills, %0, mental, div(width(%#),3) ))]
    [setq(3,max(words(%q0,|),words(%q1,|),words(%q2,|)))]
		[center(%b%chSkills%cn%b,width(%#),-)]
    
    [iter(
      after(lnum(%q3),0),
      %r[ljust(
        if(
          strmatch(extract(%q0,##,1,|),*..*),
          extract(%q0,##,1,|), 
          %b%b%b[extract(%q0,##,1,|)] 
        ), div(width(%#),3)
      )]%b
      [ljust(
        if(
          strmatch(extract(%q1,##,1,|),*..*),
          extract(%q1,##,1,|), 
          %b%b%b[extract(%q1,##,1,|)] 
        ), sub(div(width(%#),3),1) 
      )]%b
      [ljust(
        if(
          strmatch(extract(%q2,##,1,|),*..*),
          extract(%q2,##,1,|), 
          %b%b%b[extract(%q2,##,1,|)] 
        ), div(width(%#),3) 
      )]
    )]
  

/*
=============================================================================
===== fn.sheet.buildskills ==================================================

Builds a list of skills for a given category.

Registers:
  %0 - character
  %1 - category
  %2 - width (optional)

-----------------------------------------------------------------------------
*/

&fn.sheet.buildskills [v(d.cco)]=	
  [setq(0,
      iter(
          get(me/skills.%1),
          if(
              u(fn.getstat, %0, ##),
              [ulocal(fn.format, %0, ##, %2 )]|
              [iter(
                  lattr(%0/_##.*.perm),
                  [ljust(
                      %ch[before(u(
                          fn.capstr, 
                          edit(
                              after(itext(0),_[ucstr(##)].),
                              _,
                              %b
                          )
                        ),.perm)]%cn|, 
                      %2 
                  )]
              )],
            [ulocal(fn.format, %0, ##, %2)]|
          ),|
      )
  )]
  [iter(%q0,if(words(##),trim(##),%b),|,|)]

/*
=============================================================================
===== fn.sheet.disciplines ==================================================

display a list of disciplines for a character

registers:
  %0: character

-----------------------------------------------------------------------------
*/

&fn.sheet.disciplines  [v(d.cco)]=
	[center(%b%chDisciplines%cn%b, width(%#), - )]
  [iter(
  	sort(lattr(%0/_disciplines.*.perm)),
    %r[u(fn.format, %0,before(after(##,_DISCIPLINES.),.PERM),width(%#))]
    [iter(
    	sort(lattr(%0/_[before(after(itext(0),_DISCIPLINES.),.PERM)].*.perm)), 
      %r[rjust(
      	u(
        	fn.format, 
        	%0, 
          edit(
          	before(
            	after(
              	itext(0), 
              	_[before(after(##,_DISCIPLINES.),.PERM)].
              ),
              .PERM
            ) , _, %b ), sub(width(%#),5) 
        ), width(%#) 
      )]
    )]
  )]

&fn.sheet.merits [v(d.cco)] = 
	[center(%b%chMerits%cn%b,width(%#), - )]
 	[iter(
    lattr(%0/_MERITS.*.PERM),
    %R[ulocal(fn.format, %0, lcstr(before(after(##,_MERITS.),.PERM)),width(%#) )]
   )] 

&fn.sheet.flaws [v(d.cco)] = 
	[center(%b%chFlaws%cn%b, width(%#), - )]
 	[iter(
    lattr(%0/_FLAWS.*.PERM),
    %R[ulocal(fn.format, %0, lcstr(before(after(##,_FLAWS.),.PERM)),width(%#) )]
   )] 
     
&fn.sheet [v(d.cco)]=
	[center(%b%ch%ccCharacter Sheet for [name(pmatch(%0))]%cn%b,width(%#), = )]%r
	[if(
    hasattr(me, fn.sheet.bio.[get(%0/_bio.template.perm)]),
    u(fn.sheet.bio.[get(%0/_bio.template.perm)], %0),
    u(fn.sheet.bio, %0)
  )]
  [u(fn.sheet.stats, %0)]%r
  [u(fn.sheet.skills, %0)]%r
  [if(words(lattr(%0/_DISCIPLINES.*)),
  	[u(fn.sheet.disciplines, %0)]%r
  )]
  [if(words(lattr(%0/_MERITS.*)),
  	[u(fn.sheet.merits, %0)]%r
  )]
  [if(words(lattr(%0/_FLAWS.*)),
  	[u(fn.sheet.flaws, %0)]%r
  )]
  [repeat(=,width(%#))]
  
&cmd.sheet [v(d.cco)]=$+sheet:
	@pemit %#=u(fn.sheet, %#)

&cmd.sheet2 [v(d.cco)]=$+sheet *:
  // Must be staff to use this command.
  @assert orflags(%#, wWZ) = {
    @pemit %#= Permission denied.
  }

	@pemit %#=u(fn.sheet, *%0)

&fn.prereqs #34=
  	not(strmatch( 
    	iter(
  			%1,
        if(
        	strmatch(lcstr( before(##,:)), flags),
        	orflags(%0, after(##,:)),
    			strmatch(
      			lcstr(u(#31/fn.getstat, %0, before(##,:))), 
        		lcstr(after(##,:))
    			)
        )
     	), *0* 
  	))