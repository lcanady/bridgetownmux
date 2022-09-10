/*
##### STAT SYSTEM Setup #####################################################
#############################################################################
*/

@if not(hasattr(me, d.cco)) = {
  @create Chargen Command Object <CCO>;
  @fo me=&.d.cco = [search(name=Chargen Command Object <CCO>)];
  @fo me = @set v(d.cco) = safe inherit;
}


@if not(hasattr(me, d.cdo)) = {
  @create Chargen Data Object <CDO>;
  @fo me=&.d.cco = [search(name=Chargen Command Object <CCO>)];
  @fo me = @set v(d.cco) = safe inherit;
}

@va [v(d.cco)] = [get(me/d.cdo)]

/*
===== cg/wipe ===============================================================
----------------------------------------------------------------------------- 
 
 Reset your character's chargen process.

-----------------------------------------------------------------------------
*/

&cmd.cg/wipe [v(d.cco)] = $+cg/wipe:
	@dolist lattr(%#/_*) = &## %#=;
  @pemit %#=%chGame>%cn Character reset.


/*
===== cg/set ================================================================
----------------------------------------------------------------------------- 
 
  Set a chargen attribute.

  SYNTAX: +cg/set <stat> = <value>

  ---------------------------------------------------------------------------
*/

&cmd.cg/set [v(d.cco)]=$[+@]?cg\/set\s+(.*)\s*=\s*(.*)?:
	@fo %#=+stats/set %#/%1=%2;

@set [v(d.cco)]/cmd.cg/set = r

/*
===== stat/set ===============================================================
------------------------------------------------------------------------------
	
  SYTNTAX: stats/set <player>/<stat>=[<value>]
  
  This is the main command for settings stats in the V5 chargen system.
  It can currently only set stats on characters, but I might add the
  functionality for objects in the future!
  
  Setting a stat on a player other than yourself requires a Royalty bit or
  higher.  The command is no longer available once a character has been 
  approved.
  
  Registers
    1:  target
    2:  partial stat
    3:  value
  	q0: Stat type
  	q1: full stat name
  	q2: instance

------------------------------------------------------------------------------
*/


&cmd.stats [v(d.cco)]=$[+@]?stat[s]?\/set\s+(.*)\/(.*)\s*=\s*(.*)?:
	
  // Make sure they're either not approved, or are staff.
  @assert or(not(hasflag(%#,approved)), orflags(%#,wWZ)) = {
    @pemit %#= %chGame>%cn You can't set stats on approved characters.
  };
  
  // Make sure they have permissions to set stats on the given
  // character. You can only set stats on player objects.
  @assert 
    or(
      strmatach(pmatch(%1),%#),
      orflags(%#,wWZ),
      strmatch(lcstr(%1),me)
    ) = {
  		@pemit %#=Permission denied.
  };
  
  // Find and extract the partial matched stat.
  [setq(0, u(fn.whichlist, before(%2,%()) ))]
  [setq(1, ulocal(fn.statname, %2 ))]
  [setq(2, before(after(%2,%(),%)))];
  
 
  // Check to make sure it's a valid stat.
  @assert words(%q0) = {
  	  @pemit %# = %chGame>%cn That's not a valid stat.
  };
  
  // Check to see if they're allowed to set the stat.
  @assert 
  	if(
        hasattr(%va, pre.[edit(%q1,%b,_)]), 
        u( fn.prereqs, %1, get(%va/pre.[edit(%q1,%b,_)]) ),
        u( fn.prereqs, %1, get(%va/pre.[edit(%q0,%b,_)]) )
    ) =  {
  	@pemit %#= %chGame>%cn 
        [if(
            hasattr(%va, error.[edit(%q1,%b,_)]),
            get(%va/error.[edit(%q1,%b,_)]),
            default(%va/error.%q0, You can't set that here.)
        )]
  };
  
  
  // Check to see if they're allowed to set that value.
  @assert u(fn.validvalue, %q0, %q1, %3) = {
    @pemit %#= %chGame>%cn  Accepted values for %ch%q1%cn are 
      [itemize(
        iter( u(fn.getvalues, %q0, %q1) ,%ch##%cn,|,|
        ),|
      )]
  	};
  
  // If the value is blank, remove the stat!
  @if not(words(%3)) = {
    &_[if(strmatch(%q1, *.*),[edit(%q1,%b,_)],%q0.[edit(%q1,%b,_)])].perm %# =;
    &_[if(strmatch(%q1, *.*),[edit(%q1,%b,_)],%q0.[edit(%q1,%b,_)])].temp %# =;
    @dolist lattr(%#/_%1.*) = &## %#=;
    @pemit %# =%chGame>%cn Done! 
      %ch[capstr(
        [if(
          strmatch(%q1,*.*), 
          after(%q1,.),
          %q1)]
        )]%cn has been removed.;
  },
  {
    // do the thing!
    @tr me/tr.setstat = %#, if(strmatch(lcstr(%1),me),%#,pmatch(%1)), %q0, %q1, %3
  }

 // Make sure we set the command to use regex matching!
 @set [v(d.cco)]/cmd.stats = r

  
/*
----- fn.getvalues -----------------------------------------------------------

	Get the values declared for a stat via values.<stat> on the prereq system.

------------------------------------------------------------------------------
*/

&fn.getvalues [v(d.cco)]=
	switch(1,
		hasattr([v(d.cdo)],values.[edit(%1,%b,_)]), get([v(d.cdo)]/values.[edit(%1,%b,_)]),
    hasattr([v(d.cdo)],values.[%0]), get([v(d.cdo)]/values.[%0])
  )

/*
----- fn.getvalues -----------------------------------------------------------

	Get the values declared for a stat via values.<stat> on the prereq system.

------------------------------------------------------------------------------
*/

&fn.validvalue [v(d.cco)]=
	switch(1,
  	// Check to see if we have values for the specific stat.
  	neq(words(u(fn.getvalues, %0, %1),|),0), match(u(fn.getvalues,%0,%1), %2,|),
    
    // if there's no values default to passing.
    1
  )
  
  
/*
------ tr.setstat --------------------------------------------------------------

	Used to do the actual setting of the stats.  The command passes it's values
  to this trigger.  Once done, tr.setstat calls a trigger itsself.

	Registers
	%0: Executor
  %1: Target
  %2: type
  %3: name
  %4: value

------------------------------------------------------------------------------
*/

&tr.setstat [v(d.cco)]=    
	@switch 1=
    strmatch(%3, *.*), {
      &_[before(%3,.)].[edit(after(%3,.),%b,_)].perm *%1=%4;
      &_[before(%3,.)].[edit(after(%3,.),%b,_)].temp *%1=%4;
    },{
    	&_[before(%2,.)].[edit(%3,%b,_)].perm *%1=%4;
      &_[before(%2,.)].[edit(%3,%b,_)].temp *%1=%4;
    };
    
  @pemit %0=%chGame>%cn Done! %ch%3%cn has been set to %ch%4%cn;  


/*
----- fn.whichlist -----------------------------------------------------------
------------------------------------------------------------------------------
*/
&fn.whichlist [v(d.cco)] =
  first(
    trim(    
      iter(
        lattr(%va/list.*),
        if(
          match( 
            lcstr(get(%va/##)), 
            [lcstr(if(strmatch(%0,*.*),before(%0,.),%0))]*, |),
          after( ##, . )
        ) 
      )
    )
	)

/*
----- fn.statname ------------------------------------------------------------

Match a stat name from a partial match.

registers:
  %0: stat name

------------------------------------------------------------------------------
*/

&fn.statname [v(d.cco)] =
	[setq(0, list.[u(fn.whichlist,before(%0, %( ))])]
  [setq(1,after(before(%0, %)), %( ))]
  [if(
  	strmatch(%0, *.*),
    %0,
    [u(fn.capstr, extract(
      get(%va/%q0),
      lcstr(match(get(%va/%q0),[lcstr(before(%0, %())]*,|)),
      1, |
    ))]
    [if(words(%q1), %([u(fn.capstr,%q1)]%) )] 
  )]
/*
----- fn.getstat ------------------------------------------------------------
-----------------------------------------------------------------------------

get a stat value.
sytnax: getstat(<player>, <stat name>);

-----------------------------------------------------------------------------
*/
&fn.getstat [v(d.cco)] =
	default(
    %0/_
      [u(
        fn.whichlist, 
        before(%1, %()
      )].[edit(ulocal(fn.statname,%1),%b,_)].perm,
     0
  )

// Make the function into a global.
&global.fn.getstat [v(d.cco)] = u(fn.getstat, %0, %1)

/*
----- fn.getstat ------------------------------------------------------------
-----------------------------------------------------------------------------

get a stat value.
sytnax: getstat(<player>, <stat name>);

-----------------------------------------------------------------------------
*/

&fn.getstat.temp [v(d.cco)] =
	default(
    %0/_
      [u(
        fn.whichlist, 
        before(%1, %( )
      )].[edit(ulocal(fn.statname,%1),%b,_)].temp,
    0
  )

// Make the function into a global.
&global.gettempstat [v(d.cco)] = u(fn.getstat.temp, %0, %1)

/*
===== fn.prereqs =============================================================
------------------------------------------------------------------------------

The prereq system is a quick way to lock a stat to a specifc set of rules.
SYNTAX: pre.<stat> = [<stat>:<value>] [<stat>:<value>] [...]

registers:
  %0: target
  %1: prereq list.

------------------------------------------------------------------------------
*/
&fn.prereqs [v(d.cco)]=
  	not(strmatch( 
    	iter(
  			%1,
        if(
        	strmatch(lcstr( before(##,:)), flags),
        	orflags(%0, after(##,:)),
    			strmatch(
      			lcstr(u(fn.getstat, %0, before(##,:))), 
        		lcstr(after(##,:))
    			)
        )
     	), *0* 
  	))
