&cmd.cg/wipe #31 = $+cg/wipe:
	@dolist lattr(%#/_*) = &## %#=;
  @pemit %#=%chGame>%cn Character reset.


&cmd.cg/set #31=$[+@]?cg\/set\s+(.*)\s*=\s*(.*)?:
	@fo %#=+stats/set %#/%1=%2;

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


&cmd.stats #31=$[+@]?stat[s]?\/set\s+(.*)\/(.*)\s*=\s*(.*)?:
	
  // Make sure they're either not approved, or are staff.
  @assert or(not(hasflag(%#,approved)), orflags(%#,wWZ)) = {
  	msg(%#, You may not use this command once approved!)
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
  [setq(0, u(fn.whichlist, before(%2,%()) )]
  [setq(1, ulocal(fn.statname, %2 ))]
  [setq(2, before(after(%2,%(),%)))];
  
 
  // Check to make sure it's a valid stat.
  @assert words(%q0) = {
  	  @pemit %# = %chGame>%cn That's not a valid stat.
  };
  
  // Check to see if they're allowed to set the stat.
  @assert 
  	if(
        hasattr(#34,pre.[edit(%q1,%b,_)]), 
        u(#34/fn.prereqs, %1, get(#34/pre.[edit(%q1,%b,_)]) ),
        u(#34/fn.prereqs, %1, get(#34/pre.[edit(%q0,%b,_)]) )
    ) =  {
  	@pemit %#= %chGame>%cn 
        [if(
            hasattr(#34, pre.error.[edit(%q1,%b,_)]),
            get(#34/pre.error.[edit(%q1,%b,_)]),
            default(#34/pre.error.%q0, You can't set that here.)
        )]
  };
  
  
  // Check to see if they're allowed to set that value.
  @assert u(fn.validvalue, %q0, %q1, %3) = {
    @pemit %#= %chGAME>%cn  Accepted values for %ch%q1%cn are 
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
 @set #31/cmd.stats = r

  
/*
----- fn.getvalues -----------------------------------------------------------

	Get the values declared for a stat via values.<stat> on the prereq system.

------------------------------------------------------------------------------
*/

&fn.getvalues #31=
	switch(1,
		hasattr(#34,values.[edit(%1,%b,_)]), get(#34/values.[edit(%1,%b,_)]),
    hasattr(#34,values.[%0]), get(#34/values.[%0])
  )

/*
----- fn.getvalues -----------------------------------------------------------

	Get the values declared for a stat via values.<stat> on the prereq system.

------------------------------------------------------------------------------
*/

&fn.validvalue #31=
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

&tr.setstat #31=    
	@switch 1=
  	strmatch(%3, *.*), {
      &_[before(%3,.)].[edit(after(%3,.),%b,_)].perm *%1=%4;
      &_[before(%3,.)].[edit(after(%3,.),%b,_)].temp *%1=%4;
      @pemit %0=%chGame>%cn Done! %ch%3%cn has been set to %ch%4%cn;  
    },{
    	&_[before(%2,.)].[edit(%3,%b,_)].perm *%1=%4;
      &_[before(%2,.)].[edit(%3,%b,_)].temp *%1=%4;
      @pemit %0=%chGame>%cn Done! %ch%3%cn has been set to %ch%4%cn;
    }


/*
----- fn.whichlist -----------------------------------------------------------
------------------------------------------------------------------------------
*/
&fn.whichlist #31 =
  first(
    trim(    
      iter(
        lattr(#32),
        if(
          match( lcstr(get(#32/##)), [lcstr(if(strmatch(%0,*.*),before(%0,.),%0))]*, |),
          ##
        )
      )
    )
	)

&fn.whichstat #31 =
  [first(
    trim(    
      iter(
        lattr(#32),
        if(
          match( lcstr(get(#32/##)), [lcstr(if(strmatch(%0,*.*),before(%0,.),%0))]*, |),
          ##:
          [grab(
          	lcstr(get(#32/##)),
            lcstr(%0*), |
          )]
        )
      )
    )
	)]

&fn.statname #31 =
	[setq(0, u(fn.whichlist,before(%0, %( )))]
  [setq(1,after(before(%0, %)), %( ))]
  [if(
  	strmatch(%0, *.*),
    %0,
    [u(fn.capstr, extract(
      get(#32/%q0),
      lcstr(match(get(#32/%q0),[lcstr(before(%0, %())]*,|)),
      1, |
    ))]
    [if(words(%q1), %([u(fn.capstr,%q1)]%) )] 
  )]
  
&fn.getstat #31 =
	default(%0/_[u(fn.whichlist, before(%1, %())].[edit(ulocal(fn.statname,%1),%b,_)].perm, 0)

&fn.getstat.temp #31 =
	default(%0/_[u(fn.whichlist, before(%1, %( ))].[edit(ulocal(fn.statname,%1),%b,_)].temp, 0)
  
&fn.stats #31 = 
  trim(
    [ifelse(
      hasattr(#32, %1.[get(%0/_bio.template.perm)]),
      get(#32/%1.[get(%0/_bio.template.perm)]),
      get(#32/%1)
    )],|,|
  )

