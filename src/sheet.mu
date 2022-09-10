&fn.capstr #31 =
	iter(%0, capstr(lcstr(##)))
  
&fn.stats #31 = 
  trim(
    [ifelse(
      hasattr(#32, %1.[get(%0/_bio.template.perm)]),
      get(#32/%1.[get(%0/_bio.template.perm)]),
      get(#32/%1)
    )],|,|
  )

&fn.format #31 = 
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

&fn.sheet.bio #31=
 	[columns(   
    iter(
      u(fn.stats, %0, bio),
      [ljust(%ch[u(fn.capstr, ## )]:%cn, 12)]
      [u(fn.capstr,get(%0/_bio.[edit(##,%b,_)].perm))] ,|,|
    ), 39, |
	)]

/*
=============================================================================
===== fn.sheet.stata ========================================================

display a stat sheet for a character

registers:
%0: character
*/
&fn.sheet.stats #31=
	[center(%b%chAttributes%cn%b, 78, - )]%r
  [center(Physical, 26)]
  [center(Social,   26)]
  [center(Mental,   26)]%r
  [ulocal(fn.format, %0, strength)]%b
  [ulocal(fn.format, %0, charisma )]%b
  [ulocal(fn.format, %0, intelligence)]%r
  [ulocal(fn.format, %0, dexterity)]%b
  [ulocal(fn.format, %0, manipulation )]%b
  [ulocal(fn.format, %0, wits)]%r
  [ulocal(fn.format, %0, stamina)]%b
  [ulocal(fn.format, %0, composure )]%b
  [ulocal(fn.format, %0, resolve)]

/*
=============================================================================
===== fn.sheet.stata ========================================================

display a stat sheet for a character

registers:
%0: character
----------------------------------------------------------------------------
*/

&fn.sheet.skills #31=
    [setq(0,ulocal(fn.sheet.buildskills, %0, physical ))]
    [setq(1,ulocal(fn.sheet.buildskills, %0, social,  add(%qa, %qb) ))]
    [setq(2,ulocal(fn.sheet.buildskills, %0, mental))]
    [setq(3,max(words(%q0,|),words(%q1,|),words(%q2,|)))]
		[center(%b%chSkills%cn%b,78,-)]
    [iter(
      after(lnum(%q3),0),
      %r[ljust(
        if(
          strmatch(extract(%q0,##,1,|),*..*),
          extract(%q0,##,1,|), 
          %b%b%b[extract(%q0,##,1,|)] 
        ), 26 
      )]
      [ljust(
        if(
          strmatch(extract(%q1,##,1,|),*..*),
          extract(%q1,##,1,|), 
          %b%b%b[extract(%q1,##,1,|)] 
        ), 26 
      )]
      [ljust(
        if(
          strmatch(extract(%q2,##,1,|),*..*),
          extract(%q2,##,1,|), 
          %b%b%b[extract(%q2,##,1,|)] 
        ), 26 
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
*/
&fn.sheet.buildskills #31=	
  [setq(0,
      iter(
          get(me/skills.%1),
          if(
              u(fn.getstat, %0, ##),
              [ulocal(fn.format, %0, ##)]|
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
                      if(isnum(%2),%2, 24) 
                  )]
              )],
            [ulocal(fn.format, %0, ##)]|
          ),|
      )
  )]
  [iter(%q0,if(words(##),trim(##),%b),|,|)]

&fn.sheet.disciplines  #31=
	[center(%b%chDisciplines%cn%b, 78, - )]
  [iter(
  	sort(lattr(%0/_disciplines.*.perm)),
    %r[u(fn.format, %0,before(after(##,_DISCIPLINES.),.PERM),77)]
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
            ) , _, %b ), 73 
        ), 77 
      )]
    )]
  )]

&fn.sheet.merits #31 = 
	[center(%b%chMerits%cn%b,78, - )]
 	[iter(
    lattr(%0/_MERITS.*.PERM),
    %R[ulocal(fn.format, %0, lcstr(before(after(##,_MERITS.),.PERM)),77 )]
   )] 

&fn.sheet.flaws #31 = 
	[center(%b%chFlaws%cn%b, 78, - )]
 	[iter(
    lattr(%0/_FLAWS.*.PERM),
    %R[ulocal(fn.format, %0, lcstr(before(after(##,_FLAWS.),.PERM)),77 )]
   )] 
     
&fn.sheet #31=
	[center(%b%ch%ccCharacter Sheet for [name(pmatch(%0))]%cn%b,78, = )]%r
	[u(fn.sheet.bio, %0)]
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
  [repeat(=,78)]
  
&cmd.sheet #31=$+sheet:
	@pemit %#=u(fn.sheet, %#)

&cmd.sheet2 #31=$+sheet *:
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