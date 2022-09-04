/*
  == name Format (@nameformat) ==============================================
  ---------------------------------------------------------------------------
*

@nameformat #14 = 
	[center(
  	%b%ch[name(me)]
  	[if(
    	orflags(%#,wWZ), 
    	%([num(me)][flags(me)]%)%cn%b,    	
  	)],
    width(%#), =
  )]
  
@descformat #14 = %r%0%r

/*
  == Contents Format (@conformat) ===========================================
  ---------------------------------------------------------------------------
*/

@conformat #14 = 
	[center(%b%chCharacters%cn%b, width(%#), - )]
  [iter(
  	[lcon(me,CONNECT)],
    %r[ljust(moniker(##),25)]
    [rjust(singletime(idle(##)),5)]%b%b
    [mid(
      default(##/short-desc, %ch%cxType '&short-desc me=<desc>' to set this.),
      0,
      sub(width(%#),33)
    )]
  )]
  [if(not(words(lexits(me))),%r[repeat(=,width(%#))])]

 /*
  === Exit Format (@exitformat) =============================================
  --------------------------------------------------------------------------- 
*/

@exitformat #14=
  [center(%b%chExits%cn%b, width(%#), - )]%r
  [columns(
    sort(
    iter( 
    	filter(me/filter.visible,lexits(me),,|),
      ifelse(
      	hasflag(##, dark),
      	%ch%cx[setq(0, first(rest(fullname(##),;),;))]
      	[if(%q0,<[ucstr(%q0)]>%b)][name(##)],
        [setq(0, first(rest(fullname(##),;),;))]
      	[if(%q0,%ch<%cn%ch%cc[ucstr(%q0)]%cn%ch>%cn%b)]
      	%ch[name(##)]%cn
      )
  		,|,|
    ),|,|), 35, |
  )]
  [repeat(=,width(%#))]

&filter.visible #14 = 
	ifelse(
  	hasflag(%0, dark),
    if(orflags(%#,wWZ), 1),
    1
  )
